//
//  Message.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

struct Message {
    let id: String
    
    enum Content {
        case progress(Double)
        case completed(state: String)
    }
    let content: Content
}
