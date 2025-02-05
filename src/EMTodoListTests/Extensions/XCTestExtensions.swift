//
//  XCTestExtensions.swift
//  EMTodoListTests
//
//  Created by Mikhail Bereberdin on 05.02.2025.
//

import Foundation

import XCTest

extension XCTest {
    
    public func XCTAssertThrowsErrorAsync<T>(_ expression: @autoclosure () async throws -> T,
                                             _ message: @autoclosure () -> String = "",
                                             file: StaticString = #filePath, line: UInt = #line,
                                             _ errorHandler: (_ error: Error) -> Void = { _ in }) async {
        do {
            _ = try await expression()
            
            let customMessage = message()
            if customMessage.isEmpty {
                XCTFail("Asynchronous call did not throw an error.", file: file, line: line)
            } else {
                XCTFail(customMessage, file: file, line: line)
            }
        } catch {
            errorHandler(error)
        }
    }
}
