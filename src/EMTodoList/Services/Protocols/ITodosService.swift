//
//  ITodosService.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 29.01.2025.
//

import Foundation

/// Сервис для взаимодействия с задачами.
public protocol ITodosService {
    
    /// Получить задачи.
    ///
    /// - Returns: Массив задач.
    func getTodosAsync() async throws -> [TodoDto]
}
