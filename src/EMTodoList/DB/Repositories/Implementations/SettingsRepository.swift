//
//  SettingsRepository.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import CoreData

/// ``ISettingsRepository``.
public final class SettingsRepository: ISettingsRepository {
    
    // MARK: - Fields
    
    /// ``IContext``.
    private let _context: IContext
    
    // MARK: - Inits
    
    /// ``ISettingsRepository``.
    ///
    /// - Parameter context: ``IContext``.
    public init(context: IContext = CoreDataStack.shared.persistentContainer.viewContext) {
        self._context = context
    }
    
    // MARK: - Private
    
    /// Создать настройки.
    ///
    /// - Returns: Созданные настройки.
    private func create() -> Settings {
        let settings = Settings(context: _context.managedContext)
        settings.id = UUID()
        self._context.saveIfChanged()
        
        return settings
    }
    
    // MARK: - Methods
    
    public func getAsync() async throws -> Settings {
        return try await withCheckedThrowingContinuation { continuation in
            let asyncFetchRequest = Settings.asyncFetchRequest {(fetchResult) in
                guard let settings = fetchResult.finalResult?.first else {
                    let createdSettings = self.create()
                    
                    continuation.resume(returning: createdSettings)
                    
                    return
                }
                
                continuation.resume(returning: settings)
                
                return
            }
            
            do {
                _ = try self._context.execute(asyncFetchRequest)
            } catch {
                continuation.resume(throwing: SettingsRepositoryErrors.couldNotGetSettings)
            }
        }
    }
}
