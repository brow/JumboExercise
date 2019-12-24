//
//  Model.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

// A representation of the entire state of the app that allows efficiently
// updating an operation in response to message and looking up an operation's
// current state.
struct Model {
    private let orderedOperationIDs: [Operation.ID]
    private var operations: [Operation.ID: Operation.State]
    
    /// Initialize the state.
    ///
    /// - Parameters:
    ///   - operationIDs: IDs of operations to track. Each operation will have
    ///    the state `.inProgress(progress: 0)` until a message is received
    ///    concerning that operation.
    init(operationIDs: [Operation.ID]) {
        orderedOperationIDs = operationIDs
        
        operations = [:]
        for id in operationIDs {
            operations[id] = .inProgress(progress: 0)
        }
    }
    
    /// Update the appropriate operation with the given `Message`. This will
    /// have no visible effect if the message's `id` is not one of the IDs this
    /// `Model` was initialized with.
    ///
    /// - Parameters:
    ///   - message: The message.
    ///
    /// - Complexity: O(1)
    mutating func updateWith(_ message: Message) {
        operations[message.id] = message.content
    }
    
    /// The number of operations to display.
    ///
    /// - Complexity: O(1)
    var count: Int {
        return orderedOperationIDs.count
    }
    
    /// Retreive the current state of the operation at the given index.
    ///
    /// - Parameters:
    ///   - index: The index. Must be less than `count`.
    ///
    /// - Complexity: O(1)
    func operationAtIndex(_ index: Int) -> Operation {
        let id = orderedOperationIDs[index]
        return Operation(id: id, state: operations[id]!)
    }
}
