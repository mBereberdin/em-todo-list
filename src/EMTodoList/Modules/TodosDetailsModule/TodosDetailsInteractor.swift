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
    
    public weak var presenter: ITodosDetailsPresenter!
    
    public var todo: Todo?
    
    // MARK: - Inits
    
    /// ``ITodosDetailsInteractor``.
    ///
    /// - Parameter presenter: ``ITodosDetailsPresenter``.
    public init(presenter: ITodosDetailsPresenter) {
        self.presenter = presenter
        self.todo = nil
    }
    
    // MARK: - Methods
    
    public func setTodo(_ todo: Todo) {
        self.todo = todo
    }
}
