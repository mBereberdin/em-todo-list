//
//  SettingsRepositoryTests.swift
//  EMTodoListTests
//
//  Created by Mikhail Bereberdin on 05.02.2025.
//

import XCTest

import CoreData

@testable import EMTodoList

/// Тесты для - SettingsRepository.
public final class SettingsRepositoryTests: XCTestCase {
    
    // MARK: - Fields
    
    /// ``MockContext``.
    private var _context: MockContext!
    
    /// ``FakeSettings``.
    private var _fakeSettings: FakeSettings!
    
    /// ``ISettingsRepository``.
    private var _settingsRepository: ISettingsRepository!
    
    // MARK: - SetUp\TearDown
    
    /// Подготовить выполнение теста.
    public override func setUpWithError() throws {
        try super.setUpWithError()
        
        self._context = MockContext()
        self._fakeSettings = FakeSettings(context: self._context)
        self._settingsRepository = SettingsRepository(context: _context)
        
        self._fakeSettings.addIfEmpty()
    }
    
    /// Завершить выполнение теста.
    public override func tearDownWithError() throws {
        self._context = nil
        self._fakeSettings = nil
        self._settingsRepository = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - getAsync tests
    
    public func testGetAsync_WithEmptySettings_CreateSaveAndReturnNewSettings() async {
        self._fakeSettings.clear()
        let countOfSettingsBefore = self._fakeSettings.count()
        
        // Act & Assert
        await XCTAssertNoThrowAsync(try! await self._settingsRepository.getAsync())
        let countOfSettingsAfter = self._fakeSettings.count()
        XCTAssertEqual(countOfSettingsBefore, 0)
        XCTAssertEqual(countOfSettingsAfter, 1)
    }
    
    public func testGetAsync_WithEmptyExistsSettings_ReturnSettings() async {
        let countOfSettingsBefore = self._fakeSettings.count()
        
        // Act & Assert
        await XCTAssertNoThrowAsync(try! await self._settingsRepository.getAsync())
        XCTAssertEqual(countOfSettingsBefore, 1)
    }
}
