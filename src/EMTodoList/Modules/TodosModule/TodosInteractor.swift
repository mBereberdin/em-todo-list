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
