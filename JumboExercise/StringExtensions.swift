//
//  StringExtensions.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

extension String {
    /// An escaped version of the string suitable for interpolating between
    /// double quotes (") in a string containing JavaScript while preserving
    /// validity of the syntax.
    var escapingForDoubleQuoting: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
