//
//  ITodosView.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import UIKit.UIViewController

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
    
    /// Показать представление.
    ///
    /// - Parameter view: Представление, которое необходимо показать.
    func showView(_ view: UIViewController)
    
    /// Показать активность.
    ///
    /// - Parameter activityView: Представление активности.
    func showActivity(activityView: UIActivityViewController)
    
    /// Перезагрузить таблицу задач.
    func reloadTodosTable()
    
    /// Задать текст надписи количества задач.
    ///
    /// - Parameter text: Текст, который необходимо задать.
    func setTodosCountLabelText(_ text: String?)
    
    /// Добавить строку.
    ///
    /// - Parameter indexPath: Путь индекса, по которому необходимо добавить строку.
    func addRow(at indexPath: IndexPath)
    
    /// Удалить строку.
    ///
    /// - Parameter indexPath: Путь индекса строки, которую необходимо удалить.
    func removeRow(at indexPath: IndexPath)
}
