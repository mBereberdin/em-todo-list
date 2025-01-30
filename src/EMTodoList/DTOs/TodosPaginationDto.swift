//
//  TodosPaginationDto.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 29.01.2025.
//

import Foundation

/// Дто пагинации задач.
public struct TodosPaginationDto: Decodable {
    
    // MARK: - Fields
    
    /// Задачи.
    public let todos: [TodoDto]
    
    /// Общее число задач.
    public let total: Int
    
    /// Сколько первых элементов пропустить.
    public let skip: Int
    
    /// Сколько максимум элементов может быть в одном ответе.
    public let limit: Int
}
