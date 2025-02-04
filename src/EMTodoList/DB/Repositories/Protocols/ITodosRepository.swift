//
//  ITodosRepository.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Репозиторий задач.
public protocol ITodosRepository {
    
    /// Получить все задачи.
    ///
    /// - Returns: Массив задач.
    func getAllAsync() async throws -> [Todo]
    
    /// Создать задачу.
    ///
    /// - Parameters:
    ///   - id: Идентификатор.
    ///   - name: Наименование.
    ///   - creationDate: Дата создания.
    ///   - isCompleted: Флаг завершенности.
    ///   - details: Описание.
    ///   - needSave: Нужно ли сохранить задачу сразу в бд.
    ///
    /// - Returns: Созданную задачу.
    func create(id: UUID, name: String, creationDate: Date, isCompleted: Bool, details: String?, needSave: Bool) -> Todo
    
    /// Удалить задачу.
    ///
    /// - Parameter todo: Задача, которую необходимо удалить.
    func remove(_ todo: Todo)
}
