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
    
    // MARK: - Methods
    
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
            todo.isCompleted.toggle()
        }
        
        return cell
    }
    
    public func didSelectCell(in tableView: UITableView, at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
    
    /// Обновить текст надписи количества задач.
    private func updateTodosCountLabelText() {
        let text = String(format: "%d Задач", self.getNumberOfRows())
        self.view.setTodosCountLabelText(text)
    }
}
