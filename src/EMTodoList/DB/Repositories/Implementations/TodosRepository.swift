//
//  TodosRepository.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import CoreData

/// ``ITodosRepository``.
public final class TodosRepository: ITodosRepository {
    
    // MARK: - Fields
    
    /// ``IContext``.
    private let _context: IContext
    
    // MARK: - Inits
    
    /// ``ITodosRepository``.
    ///
    /// - Parameter context: ``IContext``.
    public init(context: IContext = CoreDataStack.shared.persistentContainer.viewContext) {
        self._context = context
    }
    
    // MARK: - Methods
    
    public func getAllAsync() async throws -> [Todo] {
        return try await withCheckedThrowingContinuation { continuation in
            let asyncFetchRequest = Todo.asyncFetchRequest {(fetchResult) in
                if let todos = fetchResult.finalResult {
                    continuation.resume(returning: todos)
                    
                    return
                }
                
                continuation.resume(throwing: TodosRepositoryErrors.couldNotGetTodos)
            }
            
            do {
                _ = try self._context.execute(asyncFetchRequest)
            } catch let error {
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func create(id: UUID, name: String, creationDate: Date, isCompleted: Bool, details: String?, needSave: Bool) -> Todo {
        let todo = Todo(context: self._context.managedContext)
        todo.id = id
        todo.name = name
        todo.creationDate = creationDate
        todo.isCompleted = isCompleted
        todo.details = details
        
        if needSave {
            self._context.saveIfChanged()
        }
        
        return todo
    }
    
    public func remove(_ todo: Todo) {
        self._context.delete(todo)
        self._context.saveIfChanged()
    }
}

// MARK: - Расширения-обертки для стандартных значений в протоколе.
extension ITodosRepository {
    
    public func create(id: UUID = UUID(), name: String, creationDate: Date = Date.now, isCompleted: Bool = false, details: String? = nil, needSave: Bool = false) -> Todo {
        return self.create(id: id, name: name, creationDate: creationDate, isCompleted: isCompleted, details: details, needSave: needSave)
    }
}

