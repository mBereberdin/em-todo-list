//
//  NSManagedObjectContextExtensions.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

import CoreData

extension NSManagedObjectContext {
    
    /// Сохранить если есть незафиксированные изменения.
    public func saveIfChanged() {
        guard self.hasChanges else {
            return
        }
        
        do {
            try self.save()
        } catch let error as NSError {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
}
