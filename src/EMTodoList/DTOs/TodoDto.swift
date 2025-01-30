//
//  TodoDto.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 29.01.2025.
//

import Foundation

/// Дто задачи.
public struct TodoDto: Decodable {
    
    // MARK: - Fields
    
    /// Идентификатор.
    public let id: Int
    
    /// Название.
    public let name: String
    
    /// Флаг завершенности.
    public let isCompleted: Bool
    
    /// Идентификатор пользователя.
    public let userId: Int
    
    /// Ключи кодирования.
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "todo"
        case isCompleted = "completed"
        case userId
    }
    
    // MARK: - Inits
    
    /// ``TodoDto``.
    ///
    /// - Parameter decoder: Декодер для чтения информации.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.userId = try container.decode(Int.self, forKey: .userId)
    }
}
