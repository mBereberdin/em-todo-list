//
//  IContext.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import CoreData

/// Контекст бд.
public protocol IContext {
    
    // MARK: - Fields
    
    /// Управляемый контекст.
    var managedContext: NSManagedObjectContext { get }
    
    /// Имеет ли контекст незафиксированные изменения.
    var hasChanges: Bool { get }
    
    // MARK: - Methods
    
    /// Выполнить запрос.
    ///
    /// - Parameter request: Запрос в постоянное хранилище.
    ///
    /// - Returns: Результат постоянного хранилища.
    func execute(_ request: NSPersistentStoreRequest) throws -> NSPersistentStoreResult
    
    /// Отправляет замыкание в очередь контекста для асинхронного выполнения.
    ///
    /// - Parameters:
    ///   - schedule: Требуемый график выполнения.
    ///   - block: Замыкание для выполнения.
    ///
    /// - Returns: Результат выполненного замыкания.
    func perform<T>(schedule: NSManagedObjectContext.ScheduledTaskType, _ block: @escaping () throws -> T) async rethrows -> T
    
    /// Сохранить изменения если они есть.
    func saveIfChanged()
}

// MARK: - Расширения-обертки для стандартных значений в протоколе.
extension IContext {
    
    public func perform<T>(schedule: NSManagedObjectContext.ScheduledTaskType = .immediate, _ block: @escaping () throws -> T) async rethrows -> T {
        return try await self.perform(schedule: schedule, block)
    }
}

// MARK: - NSManagedObjectContext extensions
extension NSManagedObjectContext: IContext {
    
    public var managedContext: NSManagedObjectContext {
        return self
    }
}
