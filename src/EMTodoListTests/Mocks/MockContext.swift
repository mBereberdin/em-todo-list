//
//  MockContext.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 05.02.2025.
//

import Foundation

import CoreData

@testable import EMTodoList

/// Мок контекста.
public final class MockContext: IContext {
    
    // MARK: - Fields
    
    public var hasChanges: Bool {
        return self.managedContext.hasChanges
    }
    
    public var managedContext: NSManagedObjectContext
    
    public var result: Result<Any, NSError>?
    
    // MARK: - Inits
    
    /// ``MockContext``.
    public init() {
        let container = NSPersistentContainer(name: "EMTodoList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load CoreData stack: \(error.localizedDescription)")
            }
        }
        
        self.managedContext = container.viewContext
    }
    
    // MARK: - Methods
    
    public func execute(_ request: NSPersistentStoreRequest) throws -> NSPersistentStoreResult {
        switch result {
            case .none, .success(_):
                return try self.managedContext.execute(request)
            case .failure(let error):
                throw error
        }
    }
    
    public func perform<T>(schedule: NSManagedObjectContext.ScheduledTaskType, _ block: @escaping () throws -> T) async rethrows -> T {
        return try await self.managedContext.perform(schedule: schedule, block)
    }
    
    public func delete(_ object: NSManagedObject) {
        self.managedContext.delete(object)
    }
    
    public func saveIfChanged() {
        self.managedContext.saveIfChanged()
    }
}

extension IContext {
    
    /// Колличество объектов выборки.
    ///
    /// - Parameter request: Запрос на выборку, задающий критерии поиска для выборки.
    ///
    /// - Returns: Количество объектов, которые вернул бы данный запрос на выборку,
    /// если бы он был передан в ``fetch(_:)``, или `NSNotFound`, если произошла ошибка.
    func count<T>(for request: NSFetchRequest<T>) throws -> Int where T : NSFetchRequestResult {
        return try self.managedContext.count(for: request)
    }
    
    /// Получить массив элементов указанного типа, которые соответствуют требованиям запроса на получение.
    ///
    /// Этот метод извлекает объекты из контекста и постоянные хранилища,
    /// которые вы связываете с координатором постоянного хранилища контекста. Метод регистрирует любые объекты,
    /// которые он извлекает из хранилища с контекстом.
    ///
    /// При выборке учитывайте следующее:
    ///
    /// - Если запрос на получение не имеет предиката, он возвращает все экземпляры указанной сущности.
    ///
    /// - Результаты выборки включают любой объект в контексте, который является экземпляром сущности запроса и
    /// который соответствует критериям запроса, даже если контекст еще не сохранил объект в постоянном хранилище.
    ///
    /// - Запрос на выборку оценивает состояние в памяти каждого объекта.
    /// Таким образом, результаты выборки включают любые несохраненные объекты с изменениями, которые приводят к тому,
    /// что они соответствуют критериям запроса, даже если их аналоги в постоянном хранилище этого не делают.
    /// И наоборот, результаты не включают несохраненные объекты с изменениями в памяти, которые означают,
    /// что они больше не соответствуют критериям, даже если их версии хранилища соответствуют.
    ///
    /// - Результаты получения не включают удаленные объекты, даже если контекст еще не сохранил удаление в постоянном хранилище.
    ///
    /// Выдача никогда не меняет реализованные объекты или объекты с ожидающими изменений без вмешательства разработчика.
    /// Если вы извлечите объекты, измените их, а затем выполните новую выборку, которая включает в себя надмножество этих объектов,
    /// вы не получите новых экземпляров этих объектов. Вместо этого вы получаете существующие объекты с их текущим состоянием в памяти.
    ///
    /// - Parameter request: Запрос на выборку, который определяет критерии поиска.
    ///
    /// - Returns: Массив элементов указанного типа, которые соответствуют требованиям запроса на выборку.
    public func fetch<T>(_ request: NSFetchRequest<T>, result: Result<Any, NSError>? = nil) throws -> [T] where T : NSFetchRequestResult {
        switch result {
            case .none, .success(_):
                return try self.managedContext.fetch(request)
            case .failure(let error):
                throw error
        }
    }
    
    /// Удаляет все из стека отмены, удаляет все вставки и удаления и восстанавливает обновленные объекты до их последних зафиксированных значений.
    ///
    /// Этот метод не перепроверяет данные из постоянного хранилища или хранилищ.
    public func rollback() {
        self.managedContext.rollback()
    }
}
