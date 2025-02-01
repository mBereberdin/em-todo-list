//
//  ITodosInteractor.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Интерактор задач.
///
/// Содержит всю бизнес-логику, необходимую для работы текущего модуля.
public protocol ITodosInteractor: AnyObject {
    
    // MARK: - Fields
    
    /// ``ITodosPresenter``.
    var presenter: ITodosPresenter! { get set }
    
    /// Задачи.
    var todos: [Todo] { get }
    
    // MARK: - Methods
    
    /// Инициализировать задачи если необходимо.
    ///
    /// > Tip: Необходимость определяется по параметру `Settings.needFetchTodosOnFirstLaunch`.
    ///
    /// > Throws:
    /// > - `SettingsRepositoryErrors.couldNotGetSettings` - когда не удалось получить настройки из бд.
    /// > - Ошибки типа `AFError` - когда ошибка произошла на уровне сетевого запроса.
    func initTodosIfNeed(errorHandling: ((Error)->())?)
    
    /// Загрузить задачи.
    ///
    /// > Throws:
    /// > - `TodosRepositoryErros.couldNotGetTodos` - когда не удалось получить задачи из бд.
    func loadTodos(errorHandling: ((Error)->())?)
}
