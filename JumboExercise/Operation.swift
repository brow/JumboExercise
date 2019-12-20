//
//  Operations.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

struct Operation {
    typealias Id = String
    
    enum State {
        case inProgress(Double)
        case completed(state: String)
    }
}


