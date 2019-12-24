//
//  Message.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

/// Represents a message sent by the runner script.
struct Message {
    /// The ID of the operation that the message concerns.
    let id: Operation.ID
    
    /// The new state of the operation, derived from the message's `message`,
    /// `progress`, and `state`.
    let content: Operation.State
}
