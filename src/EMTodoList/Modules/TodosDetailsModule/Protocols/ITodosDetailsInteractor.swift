//
//  ITodosDetailsInteractor.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

/// Интерактор детального представления задачи.
///
/// Содержит всю бизнес-логику, необходимую для работы текущего модуля.
public protocol ITodosDetailsInteractor: AnyObject {
    
    // MARK: - Fields
    
    /// ``ITodosDetailsPresenter``.
    var presenter: ITodosDetailsPresenter! { get set }
    
    /// Задача.
    var todo: Todo? { get }
    
    /// Блок кода, который необходимо выполнить после закрытия представления.
    var onViewDidDisappear: ((Todo?)->())? { get }
    
    // MARK: - Methods
    
    /// Установить задачу.
    ///
    /// - Parameter todo: Задачу, которую необходимо установить.
    func setTodo(_ todo: Todo)
    
    /// Создать задачу.
    ///
    /// - Parameters:
    ///   - name: Наименование, которое необходимо задать созданной задаче.
    ///   - details: Описание, которое необходимо задать созданной задаче.
    func createTodo(name: String, details: String?) -> Todo
    
    /// Обновить задачу.
    ///
    /// - Parameters:
    ///   - name: Наименование, которое необходимо задать обновляемой задаче.
    ///   - details: Описание, которое необходимо задать обновляемой задаче.
    func updateTodo(name: String, details: String?) throws
    
    /// Установить блок кода, который необходимо выполнить после закрытия представления.
    ///
    /// - Parameter completion: Блок кода.
    func setOnViewDidDisappear(completion: @escaping (Todo?)->())
}
