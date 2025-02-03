//
//  ITodosDetailsAssembler.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

/// Сборка модуля детального представления задачи.
///
/// Знает о всех зависимостях внутри модуля.
public protocol ITodosDetailsAssembler: AnyObject {
    
    /// Собрать модуль для представления.
    ///
    /// - Parameter view: Представление, для которого необходимо собрать модуль.
    func assemble(with view: ITodosDetailsView)
}
