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
            operations[id] = .inProgress(progress: 0)
        }
    }
    
    mutating func updateWith(_ message: Message) {
        operations[message.id] = message.content
    }
    
    var count: Int {
        return orderedOperationIDs.count
    }
    
    func operationAtIndex(_ index: Int) -> (Operation.ID, Operation.State) {
        let id = orderedOperationIDs[index]
        return (id, operations[id]!)
    }
}
