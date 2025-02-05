//
//  TodosRepositoryTests.swift
//  EMTodoListTests
//
//  Created by Mikhail Bereberdin on 05.02.2025.
//

import XCTest

import CoreData

@testable import EMTodoList

/// Тесты для - TodosRepository.
public final class TodosRepositoryTests: XCTestCase {
    
    // MARK: - Fields
    
    /// ``MockContext``.
    private var _context: MockContext!
    
    /// ``ITodosRepository``.
    private var _todosRepository: ITodosRepository!
    
    /// ``FakeTodos``.
    private var _fakeTodos: FakeTodos!
    
    // MARK: - SetUp\TearDown
    
    /// Подготовить выполнение теста.
    public override func setUpWithError() throws {
        try super.setUpWithError()
        
        self._context = MockContext()
        self._todosRepository = TodosRepository(context: _context)
        self._fakeTodos = FakeTodos(context: _context)
        
        self._fakeTodos.addIfEmpty()
    }
    
    /// Завершить выполнение теста.
    public override func tearDownWithError() throws {
        self._context = nil
        self._todosRepository = nil
        self._fakeTodos = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - getAllAsync tests
    
    public func testGetAllAsync_WithEmptyTodos_NotThrowReturnEmptyArray() async {
        self._fakeTodos.clear()
        
        // Act
        let todos = try! await self._todosRepository.getAllAsync()
        
        // Assert
        XCTAssertTrue(todos.isEmpty)
    }
    
    public func testGetAllAsync_WithExistsTodos_ReturnNotEmptyArray() async {
        let todosCount = self._fakeTodos.count()
        
        // Act
        let todos = try! await self._todosRepository.getAllAsync()
        
        // Assert
        XCTAssertFalse(todos.isEmpty)
        XCTAssertEqual(todos.count, todosCount)
    }
    
    public func testGetAllAsync_ForceContextError_ThrowCouldNotGetTodosError() async {
        self._context.result = .failure(NSError(domain: NSSQLiteErrorDomain, code: NSCoreDataError))
        
        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await self._todosRepository.getAllAsync()) { error in
            XCTAssertEqual(error as! TodosRepositoryErrors, TodosRepositoryErrors.couldNotGetTodos)
        }
    }
    
    // MARK: - create tests
    
    public func testCreate_ValidModelNeedSave_CreateAndSaveTodoToDb() {
        // Arrange
        let todoName = "Test create"
        
        // Act
        let _ = self._todosRepository.create(name: todoName, needSave: true)
        
        let todosAfterCreate = self._fakeTodos.get()
        
        // Assert
        XCTAssertTrue(todosAfterCreate.contains { $0.name == todoName })
    }
    
    public func testCreate_ValidModel_CreateAndNotSaveTodoToDb() {
        // Arrange
        let todoName = "Test create"
        
        // Act
        let createdTodo = self._todosRepository.create(name: todoName)
        
        // Assert
        XCTAssertTrue(createdTodo.isInserted)
    }
    
    public func testCreate_InvalidModelNeedSave_NotThrowErrorAndNotSaveTodoToDb() {
        // Arrange
        let todosCountBefore = self._fakeTodos.count()
        let invalidTodoName = ""
        
        // Act & Assert
        XCTAssertNoThrow(self._todosRepository.create(name: invalidTodoName, needSave: true))
        self._context.rollback()
        let todosCountAfter = self._fakeTodos.count()
        XCTAssertEqual(todosCountBefore, todosCountAfter)
    }
    
    // MARK: - remove tests
    
    public func testDelete_WithExistsTodo_TodoDeletedFromDb() {
        // Arrange
        let todosCountBeforeDelete = self._fakeTodos.count()
        
        // Act
        self._todosRepository.remove(self._fakeTodos.get().first!)
        
        let todosCountAfterDelete = self._fakeTodos.count()
        
        // Assert
        XCTAssertLessThan(todosCountAfterDelete, todosCountBeforeDelete)
    }
    
    public func testDelete_NotSavedTodo_NoThrowTodoDeletedFromContext() {
        // Arrange
        let todosCountBeforeCreateAndDelete = self._fakeTodos.count()
        let createdTodo = Todo(context: self._context.managedContext)
        
        // Act
        self._todosRepository.remove(createdTodo)
        
        let todosCountAfterCreateAndDelete = self._fakeTodos.count()
        
        // Assert
        XCTAssertTrue(createdTodo.isFault)
        XCTAssertEqual(todosCountBeforeCreateAndDelete, todosCountAfterCreateAndDelete)
    }
}
