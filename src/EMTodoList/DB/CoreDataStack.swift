//
//  CoreDataStack.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import CoreData

/// Стэк объектов core data.
public class CoreDataStack: ObservableObject {
    
    // MARK: - Fields
    
    /// Общий экземпляр.
    public static let shared = CoreDataStack()
    
    /// Контейнер-хранилище.
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EMTodoList")
        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = false
        }
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    // MARK: - Inits
    
    /// ``CoreDataStack``.
    private init() {}
}
