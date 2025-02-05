//
//  FakeTodos.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 05.02.2025.
//

import Foundation

import CoreData

@testable import EMTodoList

/// Фиктивные задачи.
public final class FakeTodos {
    
    // MARK: - Fields
    
    /// ``IContext``.
    private let _context: IContext
    
    // MARK: - Inits
    
    /// ``FakeTodos``.
    ///
    /// - Parameter context: ``IContext``.
    public init(context: IContext) {
        self._context = context
    }
    
    // MARK: - Methods
    
    /// Очистить существующие фиктивные задачи.
    public func clear() {
        let gotTodos = self.get()
        for todo in gotTodos {
            self._context.delete(todo)
        }
        
        self._context.saveIfChanged()
    }
    
    /// Получить существующие фиктивные задачи.
    ///
    /// - Returns: Массив ``Todo``.
    public func get() -> [Todo] {
        return try! self._context.fetch(Todo.fetchRequest())
    }
    
    /// Добавить фиктивные задачи если их нет в хранилище.
    ///
    /// > Задачи добавляются на текущую дату (`Date.now`).
    ///
    /// - Parameter countToAdd: Количество задач, которое необходимо добавить. По умолчанию - 10.
    public func addIfEmpty(countToAdd: Int = 10) {
        if self.count() > 0 {
            return
        }
        
        for counter in 0..<countToAdd {
            let todo = Todo(context: self._context.managedContext)
            todo.id = UUID()
            todo.name = "Test todo №\(counter)"
            todo.creationDate = Date.now
            
            if counter % 2 == 0 {
                todo.details = "Test todo with some details"
            }
            
            if counter % 3 == 0 {
                todo.isCompleted = true
            }
        }
        
        self._context.saveIfChanged()
    }
    
    /// Получить колличество существующих фиктивных задачи.
    ///
    /// - Returns: Колличество существующих фиктивных задачи.
    public func count() -> Int {
        return try! self._context.count(for: Todo.fetchRequest())
    }
}
