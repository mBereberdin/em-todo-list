//
//  Todo+CoreDataProperties.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//
//

import Foundation

import CoreData

extension Todo {
    
    // MARK: - Fields
    
    /// Идентификатор.
    @NSManaged public var id: UUID
    
    /// Наименование.
    @NSManaged public var name: String
    
    /// Дата создания.
    @NSManaged public var creationDate: Date
    
    /// Флаг завершенности.
    @NSManaged public var isCompleted: Bool
    
    /// Описание.
    @NSManaged public var details: String?
    
    // MARK: - Methods
    
    /// Запрос получения сущностей.
    ///
    /// - Returns: Запрос получения сущностей.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        let fetchRequest = NSFetchRequest<Todo>(entityName: Todo.entityName)
        
        return fetchRequest
    }
}

extension Todo : Identifiable {}
