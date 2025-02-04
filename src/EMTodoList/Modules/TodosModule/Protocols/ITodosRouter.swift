//
//  ITodosRouter.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Роутер задач.
///
/// Отвечает за навигацию между модулями.
public protocol ITodosRouter: AnyObject {
    
    // MARK: - Fields
    
    /// ``ITodosView``.
    var view: ITodosView! { get set }
    
    // MARK: - Methods
    
    /// Показать детальное представление задачи.
    ///
    /// - Parameter todo: Задача, детальное представление которой необходимо показать.
    /// - Parameter completion: Блок кода, который необходимо выполнить после закрытия представления.
    func showTodosDetailsView(for todo: Todo?, completion: ((Todo?)->())?)
}
