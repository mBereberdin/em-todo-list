//
//  TodosPresenter.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import UIKit.UITableView

/// ``ITodosPresenter``.
public final class TodosPresenter: ITodosPresenter {
    
    // MARK: - Fields
    
    /// Форматтер даты.
    private let _dateFormatter: DateFormatter
    
    /// Шаблон сообщения для "поделиться".
    ///
    /// > Tip: "{Название задачи}\n\n{описание задачи}"
    private let SHARE_TODO_TEMPLATE = "%@\n\n%@"
    
    public weak var view: ITodosView!
    
    public var interactor: ITodosInteractor!
    
    public var router: ITodosRouter!
    
    // MARK: - Inits
    
    /// ``ITodosPresenter``.
    ///
    /// - Parameter view: ``ITodosView``.
    public init(view: ITodosView, dateFormatter: DateFormatter) {
        self.view = view
        self._dateFormatter = dateFormatter
    }
    
    // MARK: - Private
    
    /// Обновить текст надписи количества задач.
    private func updateTodosCountLabelText() {
        let text = String(format: "%d Задач", self.getNumberOfRows())
        self.view.setTodosCountLabelText(text)
    }
    
    /// Добавить последнюю строку.
    private func addLastRow() {
        if self.interactor.isFilteringActive {
            return
        }
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.getNumberOfRows() - 1, section: 0)
            self.view.addRow(at: indexPath)
            self.updateTodosCountLabelText()
        }
    }
    
    /// Получить задачу ячейки.
    ///
    /// - Parameter index: Индекс ячейки.
    ///
    /// - Returns: Задача, которая соответствует ячейке.
    private func getCellTodo(at index: Int) -> Todo {
        let todo = self.interactor.isFilteringActive ? self.interactor.filteredTodos[index] : self.interactor.todos[index]
        
        return todo
    }
    
    // MARK: - View
    
    public func viewDidLoad() {
        self.view.configureUI()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.initTodosIfNeed { error in
                DispatchQueue.main.async {
                    self.view.showAlert(description: "Не удалось инициализировать задачи из сети.\n\(error.localizedDescription)")
                }
                
                return
            }
            
            self.interactor.loadTodos { error in
                DispatchQueue.main.async {
                    self.view.showAlert(description: "Не удалось загрузить задачи из памяти.\n\(error.localizedDescription)")
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.view.reloadTodosTable()
                self.updateTodosCountLabelText()
            }
        }
    }
    
    // MARK: - Table
    
    public func getNumberOfRows() -> Int {
        let numberOfRows = self.interactor.isFilteringActive ? self.interactor.filteredTodos.count : self.interactor.todos.count
        
        return numberOfRows
    }
    
    public func getCellFor(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EMTLTodoCell.reuseIdentifier) as? EMTLTodoCell else {
            fatalError()
        }
        
        let todo = self.interactor.isFilteringActive ? self.interactor.filteredTodos[indexPath.row] : self.interactor.todos[indexPath.row]
        cell.setTitle(todo.name)
        cell.setDetails(todo.details)
        cell.setCreationDate(self._dateFormatter.string(from: todo.creationDate))
        cell.setIsCompleted(todo.isCompleted)
        cell.onIsCompletedButtonTapped = {
            DispatchQueue.global(qos: .userInitiated).async {
                self.interactor.toggleTodosCompletion(todo)
            }
        }
        
        return cell
    }
    
    public func didSelectCell(in tableView: UITableView, at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let todo = self.interactor.isFilteringActive ? self.interactor.filteredTodos[indexPath.row] : self.interactor.todos[indexPath.row]
        self.router.showTodosDetailsView(for: todo) { _ in
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    public func getMenuFor(tableView: UITableView, at indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "trash"), attributes: .destructive) { _ in
                DispatchQueue.global(qos: .userInitiated).async {
                    let todo = self.getCellTodo(at: indexPath.row)
                    self.interactor.removeTodo(todo)
                    
                    DispatchQueue.main.async {
                        self.view.removeRow(at: indexPath)
                        self.updateTodosCountLabelText()
                    }
                }
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                DispatchQueue.global(qos: .userInitiated).async {
                    let todo = self.getCellTodo(at: indexPath.row)
                    let shareMessage = String(format:self.SHARE_TODO_TEMPLATE, todo.name, todo.details ?? "")
                    
                    let activityVC = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
                    activityVC.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                    activityVC.popoverPresentationController?.sourceView = self.view as? UIView
                    
                    DispatchQueue.main.async {
                        self.view.showActivity(activityView: activityVC)
                    }
                }
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.didSelectCell(in: tableView, at: indexPath)
            }
            
            let menu = UIMenu(children: [editAction, shareAction, deleteAction])
            
            return menu
        }
        
        return configuration
    }
    
    // MARK: - Filter
    
    public func filterTodos(by text: String?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.interactor.filterTodos(by: text)
            
            DispatchQueue.main.async {
                self.view.reloadTodosTable()
                self.updateTodosCountLabelText()
            }
        }
    }
    
    public func updateIsFilteringActive(_ isActive: Bool) {
        self.interactor.setIsFilteringActive(isActive)
    }
    
    // MARK: - Methods
    
    public func createTodo() {
        self.router.showTodosDetailsView(for: nil) { createdTodo in
            guard let createdTodo = createdTodo else {
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.interactor.addTodo(createdTodo)
                self.addLastRow()
            }
        }
    }
}
