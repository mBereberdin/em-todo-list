//
//  ISettingsRepository.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Репозиторий настроек.
public protocol ISettingsRepository {
    
    // MARK: - Methods
    
    /// Получить настройки.
    ///
    /// - Returns: Настройки.
    func getAsync() async throws -> Settings
}
