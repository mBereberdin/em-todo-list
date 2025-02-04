//
//  TodosDetailsInteractor.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

/// ``ITodosDetailsInteractor``.
public final class TodosDetailsInteractor: ITodosDetailsInteractor {
    
    // MARK: - Fields
    
    /// ``IContext``.
    private var _context: IContext
    
    /// ``ITodosRepository``.
    private var _todosRepository: ITodosRepository
    
    public weak var presenter: ITodosDetailsPresenter!
    
    public var todo: Todo?
    
    public var onViewDidDisappear: ((Todo?)->())?
    
    // MARK: - Inits
    
    /// ``ITodosDetailsInteractor``.
    ///
    /// - Parameter presenter: ``ITodosDetailsPresenter``.
    /// - Parameter context: ``IContext``.
    /// - Parameter todosRepository: ``ITodosRepository``.
    public init(presenter: ITodosDetailsPresenter, context: IContext, todosRepository: ITodosRepository) {
        self._context = context
        self._todosRepository = todosRepository
        
        self.presenter = presenter
        self.todo = nil
    }
    
    // MARK: - Methods
    
    public func setTodo(_ todo: Todo) {
        self.todo = todo
    }
    
    public func createTodo(name: String, details: String?) -> Todo {
        let createdTodo = self._todosRepository.create(name: name, details: details, needSave: true)
        
        return createdTodo
    }
    
    public func updateTodo(name: String, details: String?) throws {
        guard let todo = self.todo else {
            throw TodosDetailsInteracotrErrors.todoForUpdateIsNil
        }
        
        var hasChanges = false
        
        if todo.name != name {
            todo.name = name
            hasChanges = true
        }
        
        if todo.details != details {
            todo.details = details
            hasChanges = true
        }
        
        if !hasChanges {
            return
        }
        
        try self._context.managedContext.save()
    }
    
    public func setOnViewDidDisappear(completion: @escaping (Todo?)->()) {
        self.onViewDidDisappear = completion
    }
}
