//
//  TodoAPI.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Перечисление API задач.
public enum TodoAPI: IAPI {
    
    public static let baseUrl = URL(string: "https://dummyjson.com/")!
    
    /// ``TodosController``.
    public static let todos = TodosController.self
}
