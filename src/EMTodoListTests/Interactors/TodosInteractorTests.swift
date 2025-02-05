//
//  TodosInteractorTests.swift
//  EMTodoListTests
//
//  Created by Mikhail Bereberdin on 05.02.2025.
//

import XCTest

import CoreData

@testable import EMTodoList

/// Тесты для - TodosInteractor.
public final class TodosInteractorTests: XCTestCase {
    
    // MARK: - Fields
    
    /// ``MockContext``.
    private var _context: MockContext!
    
    /// ``FakeSettings``.
    private var _fakeSettings: FakeSettings!
    
    /// ``FakeTodos``.
    private var _fakeTodos: FakeTodos!
    
    /// ``ITodosInteractor``.
    private var _todosInteractor: ITodosInteractor!
    
    // MARK: - SetUp\TearDown
    
    /// Подготовить выполнение теста.
    public override func setUpWithError() throws {
        try super.setUpWithError()
        
        self._context = MockContext()
        
        self._fakeSettings = FakeSettings(context: self._context)
        self._fakeSettings.addIfEmpty()
        
        self._fakeTodos = FakeTodos(context: self._context)
        self._fakeTodos.addIfEmpty()
        
        let settingsRepository = SettingsRepository(context: self._context)
        let todosRepository = TodosRepository(context: self._context)
        let todosService = TodosService()
        self._todosInteractor = TodosInteractor(presenter: TodosPresenter(view: TodosView(),
                                                                          dateFormatter: EMTLTodoDateFormatter()), context: self._context,
                                                settingsRepository: settingsRepository, todosRepository: todosRepository,
                                                todosService: todosService)
    }
    
    /// Завершить выполнение теста.
    public override func tearDownWithError() throws {
        self._context = nil
        self._fakeSettings = nil
        self._fakeTodos = nil
        self._todosInteractor = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - initTodosIfNeed tests
    
    public func testInitTodosIfNeed_Need_FetchTodosFromApiAndSaveToDb() {
        let settings = self._fakeSettings.get()
        settings.needFetchTodosOnFirstLaunch = true
        self._context.saveIfChanged()
        
        self._fakeTodos.clear()
        
        // Arrange
        let countOfTodosBefore = self._fakeTodos.count()
        let expectation = self.expectation(description: "Fetch todos from api")
        
        // Act
        DispatchQueue.global(qos: .userInitiated).async {
            self._todosInteractor.initTodosIfNeed()
            expectation.fulfill()
        }
        
        self.wait(for: [expectation])
        let countOfTodosAfter = self._fakeTodos.count()
        
        // Assert
        XCTAssertEqual(countOfTodosBefore, 0)
        XCTAssertGreaterThan(countOfTodosAfter, countOfTodosBefore)
    }
    
    public func testInitTodosIfNeed_NotNeed_NotFetchTodosFromApi() {
        let settings = self._fakeSettings.get()
        settings.needFetchTodosOnFirstLaunch = false
        self._context.saveIfChanged()
        
        self._fakeTodos.clear()
        
        // Arrange
        let countOfTodosBefore = self._fakeTodos.count()
        let expectation = self.expectation(description: "Not fetch todos from api")
        
        // Act
        DispatchQueue.global(qos: .userInitiated).async {
            self._todosInteractor.initTodosIfNeed()
            expectation.fulfill()
        }
        
        self.wait(for: [expectation])
        let countOfTodosAfter = self._fakeTodos.count()
        
        // Assert
        XCTAssertEqual(countOfTodosBefore, 0)
        XCTAssertEqual(countOfTodosAfter, countOfTodosBefore)
    }
    
    public func testInitTodosIfNeed_NoSettingsAndCantCreate_ProvideCouldNotGetSettingsError() {
        self._fakeSettings.clear()
        self._context.result = .failure(NSError(domain: NSSQLiteErrorDomain, code: NSCoreDataError))
        
        // Arrange
        let expectation = self.expectation(description: "Handle error")
        
        // Act
        DispatchQueue.global(qos: .userInitiated).async {
            self._todosInteractor.initTodosIfNeed(errorHandling: { error in
                // Assert
                XCTAssertEqual(error as! SettingsRepositoryErrors, SettingsRepositoryErrors.couldNotGetSettings)
                expectation.fulfill()
            })
        }
        
        self.wait(for: [expectation])
    }
    
    // MARK: - loadTodos tests
    
    public func testLoadTodos_WithExistsTodos_SetTodos() {
        // Arrange
        let todosBefore = self._todosInteractor.todos
        let expectation = self.expectation(description: "Todos are loaded")
        
        // Act
        DispatchQueue.global(qos: .userInitiated).async {
            self._todosInteractor.loadTodos()
            expectation.fulfill()
        }
        
        self.wait(for: [expectation])
        
        let todosAfter = self._todosInteractor.todos
        
        // Assert
        XCTAssertTrue(todosBefore.isEmpty)
        XCTAssertFalse(todosAfter.isEmpty)
    }
    
    public func testLoadTodos_WithNotExistsTodos_SetEmpty() {
        self._fakeTodos.clear()
        
        // Arrange
        let todosBefore = self._todosInteractor.todos
        let expectation = self.expectation(description: "Todos are loaded")
        
        // Act
        DispatchQueue.global(qos: .userInitiated).async {
            self._todosInteractor.loadTodos()
            expectation.fulfill()
        }
        
        self.wait(for: [expectation])
        
        let todosAfter = self._todosInteractor.todos
        
        // Assert
        XCTAssertTrue(todosBefore.isEmpty)
        XCTAssertTrue(todosAfter.isEmpty)
        
    }
    
    public func testLoadTodos_ForceContextError_HandleError() {
        self._context.result = .failure(NSError(domain: NSSQLiteErrorDomain, code: NSCoreDataError))
        
        // Arrange
        let expectation = self.expectation(description: "Handle error")
        
        // Act
        DispatchQueue.global(qos: .userInitiated).async {
            self._todosInteractor.loadTodos(errorHandling: { error in
                // Assert
                XCTAssertEqual(error as! TodosRepositoryErrors, TodosRepositoryErrors.couldNotGetTodos)
                expectation.fulfill()
            })
        }
        
        self.wait(for: [expectation])
    }
    
    // MARK: - filterTodos tests
    
    public func testFilterTodos_SomeTodosMatchText_SetMatchedTodosToFilteredTodos() {
        let expectation = self.expectation(description: "Await todos loading")
        DispatchQueue.global().async {
            self._todosInteractor.loadTodos()
            expectation.fulfill()
        }
        self.wait(for: [expectation])
        
        // Arrange
        let existsTodo = self._fakeTodos.get().first!
        let halfOfTodosNameIndex = existsTodo.name.index(existsTodo.name.endIndex, offsetBy: -existsTodo.name.count / 2)
        let searchText = String(existsTodo.name[...halfOfTodosNameIndex])
        
        let filteredTodosBefore = self._todosInteractor.filteredTodos
        
        // Act
        self._todosInteractor.filterTodos(by: searchText)
        
        let filteredTodosAfter = self._todosInteractor.filteredTodos
        
        // Assert
        XCTAssertTrue(filteredTodosBefore.isEmpty)
        XCTAssertGreaterThan(filteredTodosAfter.count, filteredTodosBefore.count)
    }
    
    public func testFilterTodos_TextIsEmpty_SetAllTodosToFilteredTodos() {
        let expectation = self.expectation(description: "Await todos loading")
        DispatchQueue.global().async {
            self._todosInteractor.loadTodos()
            expectation.fulfill()
        }
        self.wait(for: [expectation])
        
        // Arrange
        let searchText = ""
        
        let filteredTodosBefore = self._todosInteractor.filteredTodos
        
        // Act
        self._todosInteractor.filterTodos(by: searchText)
        
        let filteredTodosAfter = self._todosInteractor.filteredTodos
        
        // Assert
        XCTAssertTrue(filteredTodosBefore.isEmpty)
        XCTAssertGreaterThan(filteredTodosAfter.count, filteredTodosBefore.count)
        XCTAssertEqual(self._todosInteractor.todos, self._todosInteractor.filteredTodos)
    }
    
    public func testFilterTodos_NoOneTodoMatchesText_SetEmptyToFilteredTodos() {
        let expectation = self.expectation(description: "Await todos loading")
        DispatchQueue.global().async {
            self._todosInteractor.loadTodos()
            expectation.fulfill()
        }
        self.wait(for: [expectation])
        
        // Arrange
        let searchText = "Random text that does not match any todo"
        
        let filteredTodosBefore = self._todosInteractor.filteredTodos
        
        // Act
        self._todosInteractor.filterTodos(by: searchText)
        
        let filteredTodosAfter = self._todosInteractor.filteredTodos
        
        // Assert
        XCTAssertTrue(filteredTodosBefore.isEmpty)
        XCTAssertTrue(filteredTodosAfter.isEmpty)
    }
    
    // MARK: - setIsFilteringActive tests
    
    public func testSetIsFilteringActive_AnotherValue_IsFilteringActiveEqualAnotherValue() {
        // Arrange
        let isActiveBefore = self._todosInteractor.isFilteringActive
        
        // Act
        self._todosInteractor.setIsFilteringActive(!isActiveBefore)
        
        let isActiveAfter = self._todosInteractor.isFilteringActive
        
        // Assert
        XCTAssertNotEqual(isActiveBefore, isActiveAfter)
    }
    
    // MARK: - addTodo tests
    
    public func testAddTodo_Todo_AddTodoToTodos() {
        // Arrange
        let todosBefore = self._todosInteractor.todos
        let todo = self._fakeTodos.get().first!
        
        // Act
        self._todosInteractor.addTodo(todo)
        
        let todosAfter = self._todosInteractor.todos
        
        // Assert
        XCTAssertTrue(todosBefore.isEmpty)
        XCTAssertNotEqual(todosBefore, todosAfter)
    }
    
    // MARK: - removeTodo tests
    
    public func testRemoveTodo_Todo_RemoveTodoFromTodosAndFilteredTodosIfContains() {
        let expectation = self.expectation(description: "Await todos loading")
        DispatchQueue.global().async {
            self._todosInteractor.loadTodos()
            expectation.fulfill()
        }
        self.wait(for: [expectation])
        
        let existsTodo = self._todosInteractor.todos.first!
        self._todosInteractor.filterTodos(by: existsTodo.name)
        
        // Arrange
        let todosContainsBefore = self._todosInteractor.todos.firstIndex(of: existsTodo) != nil
        let filteredTodosContainsBefore = self._todosInteractor.filteredTodos.firstIndex(of: existsTodo) != nil
        
        // Act
        self._todosInteractor.removeTodo(existsTodo)
        
        let todosContainsAfter = self._todosInteractor.todos.firstIndex(of: existsTodo) != nil
        let filteredTodosContainsAfter = self._todosInteractor.filteredTodos.firstIndex(of: existsTodo) != nil
        
        // Assert
        XCTAssertTrue(todosContainsBefore)
        XCTAssertTrue(filteredTodosContainsBefore)
        XCTAssertFalse(todosContainsAfter)
        XCTAssertFalse(filteredTodosContainsAfter)
    }
    
    // MARK: - toggleTodosCompletion tests
    
    public func testToggleTodosCompletion_TodosCompletionIsInverted() {
        let expectation = self.expectation(description: "Await todos loading")
        DispatchQueue.global().async {
            self._todosInteractor.loadTodos()
            expectation.fulfill()
        }
        self.wait(for: [expectation])
        
        let existsTodo = self._todosInteractor.todos.first!
        
        // Arrange
        let todosCompletionBefore = existsTodo.isCompleted
        
        // Act
        self._todosInteractor.toggleTodosCompletion(existsTodo)
        
        let todosCompletionAfter = existsTodo.isCompleted
        
        // Assert
        XCTAssertNotEqual(todosCompletionBefore, todosCompletionAfter)
        XCTAssertFalse(existsTodo.isUpdated)
    }
}
