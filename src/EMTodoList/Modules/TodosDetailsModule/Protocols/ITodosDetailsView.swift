//
//  ITodosDetailsView.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

/// Детальное представление задачи.
///
/// Отвечает за отображение данных на экране и оповещает Presenter о действиях пользователя.
/// Пассивен, сам никогда не запрашивает данные, только получает их от презентера.
public protocol ITodosDetailsView: AnyObject {
    
    // MARK: - Fields
    
    /// ``ITodosDetailsPresenter``.
    var presenter: ITodosDetailsPresenter! { get set }
    
    /// ``ITodosDetailsAssembler``.
    var assembler: ITodosDetailsAssembler { get }
    
    // MARK: - Methods
    
    /// Настроить ui.
    func configureUI()
    
    /// Скрыть клавиатуру.
    func hideKeyboard()
    
    /// Добавить распознаватель нажатий.
    func addViewTapRecognizer()
    
    /// Показать предупреждение.
    ///
    /// - Parameters:
    ///   - title: Заголовок.
    ///   - description: Описание.
    func showAlert(title: String, description: String)
    
    // MARK: - Get from \ Set to ui elements
    
    /// Установить заголовок.
    ///
    /// - Parameter text: Текст, который необходимо установить в качестве заголовка.
    func setTitle(_ text: String?)
    
    /// Установить дату.
    ///
    /// - Parameter date: Дата в формате строки, которую необходимо установить.
    func setDate(_ date: String?)
    
    /// Установить описание задачи.
    ///
    /// - Parameter details: Описание задачи, которое необходимо установить.
    func setDetails(_ details: String?)
    
    /// Получить заголовок.
    ///
    /// - Returns: Текст заголовка.
    func getTitle() -> String?
    
    /// Получить описание.
    ///
    /// - Returns: Текст описания.
    func getDetails() -> String?
    
    // MARK: - To presenter
    
    /// Предоставить задачу.
    ///
    /// - Parameter todo: Задачу, которую необходимо предоставить.
    func provideTodo(_ todo: Todo)
    
    /// Установить блок кода, который необходимо выполнить после закрытия представления.
    ///
    /// - Parameter completion: Блок кода.
    func setOnViewDidDisappear(completion: @escaping (Todo?)->())
}
