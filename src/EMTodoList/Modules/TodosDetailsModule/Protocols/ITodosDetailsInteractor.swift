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
    
    // MARK: - Methods
    
    /// Установить задачу.
    ///
    /// - Parameter todo: Задачу, которую необходимо установить.
    func setTodo(_ todo: Todo)
}

