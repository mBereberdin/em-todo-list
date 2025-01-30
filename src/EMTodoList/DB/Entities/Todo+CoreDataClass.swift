//
//  Todo+CoreDataClass.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//
//

import Foundation

import CoreData

@objc(Todo)
public class Todo: NSManagedObject {
    
    // MARK: - Fields
    
    /// Наименование сущности.
    public static let entityName = Todo.description()
    
    // MARK: - Methods
    
    /// Асинхронный запрос получения сущностей.
    ///
    /// - Parameter completion: Блок кода, которому будут предоставлены сущности после их асинхронного получения.
    ///
    /// - Returns: Асинхронный запрос получения сущностей.
    public class func asyncFetchRequest(completion: ((NSAsynchronousFetchResult<Todo>)->())?) -> NSAsynchronousFetchRequest<Todo> {
        let asyncFetchRequest = NSAsynchronousFetchRequest<Todo>(fetchRequest: Todo.fetchRequest(), completionBlock: completion)
        
        return asyncFetchRequest
    }
}
