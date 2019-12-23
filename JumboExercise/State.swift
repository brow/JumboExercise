//
//  State.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

struct State {
    private let orderedOperationIDs: [Operation.ID]
    private var operations: [Operation.ID: Operation.State]
    
    init(operationIDs: [Operation.ID]) {
        orderedOperationIDs = operationIDs
        
        operations = [:]
        for id in operationIDs {
            operations[id] = .inProgress(0)
        }
    }
    
    mutating func updateWith(_ message: Message) {
        operations[message.id] = message.content
    }
    
    var orderedOperations: [(Operation.ID, Operation.State)] {
        return orderedOperationIDs.compactMap { id in
            if let state = operations[id] {
                return (id, state)
            } else {
                return nil
            }
        }
    }
}
