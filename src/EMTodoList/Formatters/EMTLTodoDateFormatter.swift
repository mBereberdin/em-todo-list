//
//  EMTLTodoDateFormatter.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

/// Форматтер даты задачи.
public final class EMTLTodoDateFormatter: DateFormatter, @unchecked Sendable {
    
    // MARK: - Inits
    
    /// ``EMTLTodoDateFormatter``.
    public override init() {
        super.init()
        
        self.dateFormat = "dd/MM/yy"
    }
    
    /// ``EMTLTodoDateFormatter``.
    ///
    /// - Parameter coder: Кодировщик.
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
