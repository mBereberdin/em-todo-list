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
}
