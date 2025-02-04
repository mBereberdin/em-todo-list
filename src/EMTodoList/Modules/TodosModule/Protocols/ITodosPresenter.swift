//
//  ITodosPresenter.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import UIKit.UITableView

/// Презентер задач.
///
/// Получает от View информацию о действиях пользователя и преображает ее в запросы к Router’у,
/// Interactor’у, а также получает данные от Interactor’a, подготавливает их и отправляет View для отображения.
public protocol ITodosPresenter: AnyObject {
    
    // MARK: - Fields
    
    /// ``ITodosView``.
    var view: ITodosView! { get set }
    
    /// ``ITodosInteractor``.
    var interactor: ITodosInteractor! { get set }
    
    /// ``ITodosRouter``.
    var router: ITodosRouter! { get set }
    
    // MARK: - View
    
    /// Представление было загружено.
    func viewDidLoad()
    
    // MARK: - Table
    
    /// Получить количество строк таблицы задач.
    ///
    /// - Returns: Количество строк таблицы задач.
    func getNumberOfRows() -> Int
    
    /// Получить ячейку для таблицы задач.
    ///
    /// - Parameters:
    ///   - tableView: Таблица задач, запрашивающая ячейку.
    ///   - indexPath: Путь индекса, идентифицирующий ячейку.
    ///
    /// - Returns: Ячейку таблицы задач.
    func getCellFor(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    
    /// Была выбрана ячейка.
    ///
    /// - Parameters:
    ///   - tableView: Таблица, в которой была выбрана ячейка.
    ///   - indexpath: Путь индекса, идентифицирующий ячейку.
    func didSelectCell(in tableView: UITableView, at indexPath: IndexPath)
    
    // MARK: - Filter
    
    /// Отфильтровать задачи.
    ///
    /// - Parameter text: Текст, на основании которого происходит фильтрация.
    func filterTodos(by text: String?)
    
    /// Обновить статус фильтрации.
    ///
    /// - Parameter isActive: Активна ли сейчас фильтрация.
    func updateIsFilteringActive(_ isActive: Bool)
    
    // MARK: - Methods
    
    /// Создать задачу.
    func createTodo()
}
