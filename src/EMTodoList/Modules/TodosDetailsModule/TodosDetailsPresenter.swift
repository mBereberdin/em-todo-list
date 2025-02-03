//
//  TodosDetailsPresenter.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

/// ``ITodosDetailsPresenter``.
public final class TodosDetailsPresenter: ITodosDetailsPresenter {
    
    // MARK: - Fields
    
    /// Форматтер даты.
    private let _dateFormatter: DateFormatter
    
    public weak var view: ITodosDetailsView!
    
    public var interactor: ITodosDetailsInteractor!
    
    // MARK: - Inits
    
    /// ``ITodosDetailsPresenter``.
    ///
    /// - Parameter view: ``ITodosDetailsView``.
    /// - Parameter dateFormatter: Форматтер даты.
    public init(view: ITodosDetailsView, dateFormatter: DateFormatter) {
        self.view = view
        self._dateFormatter = dateFormatter
    }
    
    // MARK: - Methods
    
    public func viewDidLoad() {
        self.view.configureUI()
        
        self.view.addViewTapRecognizer()
        
        self.setTodosInfo()
    }
    
    public func viewTapped() {
        self.view.hideKeyboard()
    }
    
    private func setTodosInfo () {
        guard let todo = interactor.todo else {
            return
        }
        
        let date = _dateFormatter.string(from: todo.creationDate)
        self.view.setDate(date)
        self.view.setTitle(todo.name)
        self.view.setDetails(todo.details)
    }
    
    public func provideTodo(_ todo: Todo) {
        self.interactor.setTodo(todo)
    }
}

