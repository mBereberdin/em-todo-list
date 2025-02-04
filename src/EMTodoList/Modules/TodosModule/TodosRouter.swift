//
//  TodosRouter.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// ``ITodosRouter``.
public final class TodosRouter: ITodosRouter {
    
    // MARK: - Fields
    
    public weak var view: ITodosView!
    
    // MARK: - Inits
    
    /// ``ITodosRouter``.
    ///
    /// - Parameter view: ``ITodosView``.
    public init(view: ITodosView) {
        self.view = view
    }
    
    // MARK: - Methods
    
    public func showTodosDetailsView(for todo: Todo?, completion: ((Todo?)->())?) {
        let todosDetailsView = TodosDetailsView()
        if let todo = todo {
            todosDetailsView.provideTodo(todo)
        }
        
        if let completion = completion {
            todosDetailsView.setOnViewDidDisappear(completion: completion)
        }
        
        self.view.showView(todosDetailsView)
    }
}

// MARK: - ITodosRouter defaults extensions
extension ITodosRouter {
    
    public func showTodosDetailsView(for todo: Todo?, completion: ((Todo?)->())? = nil) {
        self.showTodosDetailsView(for: todo, completion: completion)
    }
}
