//
//  TodosController.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Перечисление конечных точек контроллера задач.
public enum TodosController: IAPI {
    
    // MARK: - Fields
    
    public static let baseUrl: URL = TodoAPI.baseUrl.appendingPathComponent("todos")
}
