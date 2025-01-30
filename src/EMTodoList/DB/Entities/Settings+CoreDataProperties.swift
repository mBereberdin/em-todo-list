//
//  Settings+CoreDataProperties.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//
//

import Foundation

import CoreData

extension Settings {
    
    /// Идентификатор.
    @NSManaged public var id: UUID
    
    /// Нужно ли притягивать задачи при первом запуске.
    @NSManaged public var needFetchTodosOnFirstLaunch: Bool
    
    // MARK: - Methods
    
    /// Запрос получения сущностей.
    ///
    /// - Returns: Запрос получения сущностей.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        let fetchRequest = NSFetchRequest<Settings>(entityName: Settings.entityName)
        
        return fetchRequest
    }
}

extension Settings : Identifiable {}
