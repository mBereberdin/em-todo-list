//
//  ITodosAssembler.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// Сборка модуля задач.
///
/// Знает о всех зависимостях внутри модуля.
public protocol ITodosAssembler: AnyObject {
    
    /// Собрать модуль для представления.
    ///
    /// - Parameter view: Представление, для которого необходимо собрать модуль.
    func assemble(with view: ITodosView)
}
