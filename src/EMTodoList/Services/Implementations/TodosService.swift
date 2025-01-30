//
//  TodosService.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 29.01.2025.
//

import Foundation

import Alamofire

/// ``ITodosService``.
public final class TodosService: ITodosService {
    
    // MARK: - Fields
    
    /// Заголовки запросов к контроллеру задач.
    private let HEADERS: HTTPHeaders = [
        .accept("application/json")
    ]
    
    // MARK: - Methods
    
    public func getTodosAsync() async throws -> [TodoDto] {
        let todos = try await AF.request(TodoAPI.todos.baseUrl, method: .get, headers: HEADERS)
            .validate()
            .serializingDecodable(TodosPaginationDto.self)
            .value
            .todos
        
        return todos
    }
}
