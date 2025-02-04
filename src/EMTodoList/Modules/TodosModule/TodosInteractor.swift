//
//  TodosInteractor.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// ``ITodosInteractor``.
public final class TodosInteractor: ITodosInteractor {
    
    // MARK: - Fields
    
    /// ``IContext``.
    private let _context: IContext
    
    /// ``ISettingsRepository``.
    private let _settingsRepository: ISettingsRepository
    
    /// ``ITodosRepository``.
    private let _todosRepository: ITodosRepository
    
    /// ``ITodosService``.
    private let _todosService: ITodosService
    
    public weak var presenter: ITodosPresenter!
    
    public var todos: [Todo]
    
    public var filteredTodos: [Todo]
    
    public var isFilteringActive: Bool
    
    // MARK: - Inits
    
    /// ``ITodosInteractor``.
    ///
    /// - Parameter context: ``IContext``.
    /// - Parameter presenter: ``ITodosPresenter``.
    /// - Parameter settingsRepository: ``ISettingsRepository``.
    /// - Parameter todosRepository: ``ITodosRepository``.
    /// - Parameter todosService: ``ITodosService``.
    public init(presenter: ITodosPresenter, context: IContext, settingsRepository: ISettingsRepository,
                todosRepository: ITodosRepository, todosService: ITodosService) {
        self._context = context
        self._settingsRepository = settingsRepository
        self._todosRepository = todosRepository
        self._todosService = todosService
        
        self.presenter = presenter
        self.todos = []
        self.filteredTodos = []
        self.isFilteringActive = false
    }
    
    // MARK: - Methods
    
    public func loadTodos(errorHandling: ((Error)->())?) {
        // Т.к. в репозитории метод реализовал через swift concurrency, а не @escaping closure: (([Todo])->()) -
        // воспользуюсь семафором для синхронизации потоков, хотя плохо что поток будет без дела висеть и ждать(
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            defer { semaphore.signal() }
            
            do {
                self.todos = try await self._todosRepository.getAllAsync()
            } catch let error {
                errorHandling?(error)
            }
        }
        
        semaphore.wait()
    }
    
    public func initTodosIfNeed(errorHandling: ((Error)->())?) {
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            defer { semaphore.signal() }
            
            do {
                let settings = try await self._settingsRepository.getAsync()
                if !settings.needFetchTodosOnFirstLaunch {
                    return
                }
                
                let gotTodos = try await self._todosService.getTodosAsync()
                for todo in gotTodos {
                    _ = self._todosRepository.create(name: todo.name, isCompleted: todo.isCompleted,
                                                     details: "Fetched todo without description.")
                }
                
                settings.needFetchTodosOnFirstLaunch = false
                
                self._context.saveIfChanged()
            } catch let error {
                errorHandling?(error)
            }
        }
        
        semaphore.wait()
    }
    
    public func filterTodos(by text: String?) {
        guard let text = text, !text.isEmpty else {
            self.filteredTodos = self.todos
            
            return
        }
        
        // Возможно, эффективнее будет делать фильтрацию по средствам sqlite в core data, но это надо тестить и текущая
        // реализация просто пишется быстрее, учитывая сжатый срок.
        self.filteredTodos = self.todos.filter { todo in
            let lowercasedText = text.lowercased()
            let isNameContainsText = todo.name.lowercased().contains(lowercasedText)
            let isDetailsContainsText = todo.details?.lowercased().contains(lowercasedText) ?? false
            
            return isNameContainsText || isDetailsContainsText
        }
    }
    
    public func setIsFilteringActive(_ isActive: Bool) {
        self.isFilteringActive = isActive
    }
    
    public func addTodo(_ todo: Todo) {
        self.todos.append(todo)
    }
    
    public func removeTodo(_ todo: Todo) {
        self._todosRepository.remove(todo)
        
        guard let indexOfTodo = self.todos.firstIndex(of: todo) else {
            return
        }
        self.todos.remove(at: indexOfTodo)
        
        guard let indexOfTodo = self.filteredTodos.firstIndex(of: todo) else {
            return
        }
        self.filteredTodos.remove(at: indexOfTodo)
    }
}

// MARK: - ITodosInteractor defaults extensions
extension ITodosInteractor {
    
    public func loadTodos(errorHandling: ((Error)->())? = nil) {
        self.loadTodos(errorHandling: errorHandling)
    }
    
    public func initTodosIfNeed(errorHandling: ((Error)->())? = nil) {
        self.initTodosIfNeed(errorHandling: errorHandling)
    }
}
