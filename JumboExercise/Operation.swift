//
//  Operation.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

/// Represents an operation, about which we receive messages and display
/// progress.
struct Operation {
    typealias ID = String
    
    enum State {
        // `Double` is chosen to match the precison of JavaScript's Number type.
        // The value is expected to be in [0, 100], but this is not checked.
        case inProgress(progress: Double)
        
        // `state` might be, e.g., "completed" or "success", but the set of
        // possible values is not documented, so all are allowed.
        case completed(state: String)
    }
    
    /// A case-sensitive unique identifier for the operation, which is also used
    /// as its human-readable name where the operation is displayed.
    let id: ID
    
    /// The state of the operation.
    let state: State
}
