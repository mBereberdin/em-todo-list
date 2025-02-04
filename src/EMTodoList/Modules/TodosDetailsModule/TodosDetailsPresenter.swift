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
    
    // MARK: - Private
    
    /// Установить информацию о задаче.
    private func setTodosInfo () {
        guard let todo = interactor.todo else {
            return
        }
        
        let date = _dateFormatter.string(from: todo.creationDate)
        self.view.setDate(date)
        self.view.setTitle(todo.name)
        self.view.setDetails(todo.details)
    }
    
    // MARK: - View
    
    public func viewDidLoad() {
        self.view.configureUI()
        
        self.view.addViewTapRecognizer()
        
        self.setTodosInfo()
    }
    
    public func viewDidDisappear() {
        let details = self.view.getDetails() ?? ""
        var name = self.view.getTitle() ?? ""
        if name.isEmpty {
            if details.isEmpty {
                return
            }
            
            name = "Без названия"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if self.interactor.todo == nil {
                let createdTodo = self.interactor.createTodo(name: name, details: details)
                self.interactor.onViewDidDisappear?(createdTodo)
                
                return
            }
            
            do {
                try self.interactor.updateTodo(name: name, details: details)
            } catch let error {
                self.view.showAlert(description: "Не удалось обновить задачу.\n\(error.localizedDescription)")
            }
            
            self.interactor.onViewDidDisappear?(nil)
        }
    }
    
    public func viewTapped() {
        self.view.hideKeyboard()
    }
    
    // MARK: - Methods
    
    public func getCurrentDate() -> String {
        let date = self._dateFormatter.string(from: Date.now)
        
        return date
    }
    
    // MARK: - To interactor
    
    public func provideTodo(_ todo: Todo) {
        self.interactor.setTodo(todo)
    }
    
    public func setOnViewDidDisappear(completion: @escaping (Todo?)->()) {
        self.interactor.setOnViewDidDisappear(completion: completion)
    }
}
