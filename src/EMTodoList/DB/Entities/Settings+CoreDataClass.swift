//
//  Settings+CoreDataClass.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//
//

import Foundation

import CoreData

@objc(Settings)
public class Settings: NSManagedObject {
    
    // MARK: - Fields
    
    /// Наименование сущности.
    public static let entityName = Settings.description()
    
    // MARK: - Methods
    
    /// Асинхронный запрос получения сущностей.
    ///
    /// - Parameter completion: Блок кода, которому будут предоставлены сущности после их асинхронного получения.
    ///
    /// - Returns: Асинхронный запрос получения сущностей.
    public class func asyncFetchRequest(completion: ((NSAsynchronousFetchResult<Settings>)->())?) -> NSAsynchronousFetchRequest<Settings> {
        let asyncFetchRequest = NSAsynchronousFetchRequest<Settings>(fetchRequest: Settings.fetchRequest(), completionBlock: completion)
        
        return asyncFetchRequest
    }
}
