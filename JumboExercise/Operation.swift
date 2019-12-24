//
//  Operation.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

struct Operation {
    typealias ID = String
    
    enum State {
        case inProgress(progress: Double)
        
        // `state` might be, e.g., "completed" or "success", but the set of
        // possible values is not documented.
        case completed(state: String)
    }
    
    let id: ID
    let state: State
}
