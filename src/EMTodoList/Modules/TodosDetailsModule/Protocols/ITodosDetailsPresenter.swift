//
//  ITodosDetailsPresenter.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

import UIKit.UITableView

/// Презентер детального представления задачи.
///
/// Получает от View информацию о действиях пользователя и преображает ее в запросы к Router’у,
/// Interactor’у, а также получает данные от Interactor’a, подготавливает их и отправляет View для отображения.
public protocol ITodosDetailsPresenter: AnyObject {
    
    // MARK: - Fields
    
    /// ``ITodosDetailsView``.
    var view: ITodosDetailsView! { get set }
    
    /// ``ITodosDetailsInteractor``.
    var interactor: ITodosDetailsInteractor! { get set }
    
    // MARK: - Methods
    
    /// Представление было загружено.
    func viewDidLoad()
    
    /// Предоставить задачу.
    ///
    /// - Parameter todo: Задачу, которую необходимо предоставить.
    func provideTodo(_ todo: Todo)
    
    /// Представление было нажато.
    func viewTapped()
}
