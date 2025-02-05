//
//  FakeSettings.swift
//  EMTodoListTests
//
//  Created by Mikhail Bereberdin on 05.02.2025.
//

import Foundation

import CoreData

@testable import EMTodoList

/// Фиктивные настройки.
public final class FakeSettings {
    
    // MARK: - Fields
    
    /// ``IContext``.
    private let _context: IContext
    
    // MARK: - Inits
    
    /// ``FakeSettings``.
    ///
    /// - Parameter context: ``IContext``.
    public init(context: IContext) {
        self._context = context
    }
    
    // MARK: - Methods
    
    /// Очистить существующие фиктивные настройки.
    public func clear() {
        let gotSettings = self.get()
        self._context.delete(gotSettings)
        
        self._context.saveIfChanged()
    }
    
    /// Получить существующие фиктивные настройки.
    ///
    /// - Returns: Настройки.
    public func get() -> Settings {
        return try! self._context.fetch(Settings.fetchRequest()).first!
    }
    
    /// Добавить фиктивные настройки если их нет в хранилище.
    public func addIfEmpty() {
        if self.count() > 0 {
            return
        }
        
        let settings = Settings(context: self._context.managedContext)
        settings.id = UUID()
        
        self._context.saveIfChanged()
    }
    
    /// Получить количество существующих фиктивных настроек.
    ///
    /// - Returns: Количество существующих фиктивных настроек.
    public func count() -> Int {
        return try! self._context.count(for: Settings.fetchRequest())
    }
}
