//
//  StringExtensionsTests.swift
//  StringExtensionsTests
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import XCTest
@testable import JumboExercise

class StringExtensionsTests: XCTestCase {
    func testStringEscapingForDoubleQuoting() {
        XCTAssertEqual(
            "jumbo".escapingForDoubleQuoting,
            "jumbo")
        XCTAssertEqual(
            "\"Dark Web\"".escapingForDoubleQuoting,
            "\\\"Dark Web\\\"")
        XCTAssertEqual(
            "\\n".escapingForDoubleQuoting,
            "\\\\n")
    }
}
