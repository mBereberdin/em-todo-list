//
//  ITodosView.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Представление просмотра задач.
///
/// Отвечает за отображение данных на экране и оповещает Presenter о действиях пользователя.
/// Пассивен, сам никогда не запрашивает данные, только получает их от презентера.
public protocol ITodosView: AnyObject {
    
    // MARK: - Fields
    
    /// ``ITodosPresenter``.
    var presenter: ITodosPresenter! { get set }
    
    /// ``ITodosAssembler``.
    var assembler: ITodosAssembler { get }
    
    // MARK: - Methods
    
    /// Настроить ui.
    func configureUI()
    
    /// Показать предупреждение.
    ///
    /// - Parameters:
    ///   - title: Заголовок.
    ///   - description: Описание.
    func showAlert(title: String, description: String)
    
    /// Перезагрузить таблицу задач.
    func reloadTodosTable()
}
