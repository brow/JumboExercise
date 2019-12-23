//
//  StringExtensions.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

extension String {
    var escapingForDoubleQuoting: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
