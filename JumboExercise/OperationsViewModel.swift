//
//  OperationsViewModel.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

protocol OperationsViewModel {
    typealias CellModel = (
        text: String,
        detailText: String?,
        progress: Float?)
    
    var count: Int { get}
    func cellModelAtIndex(_ index: Int) -> CellModel
}

extension Model: OperationsViewModel {
    func cellModelAtIndex(_ index: Int) -> Self.CellModel {
        let operation = operationAtIndex(index)
        let text = operation.id
        
        switch operation.state {
        case .inProgress(let progress):
            return (
                text: text,
                progress: Float(progress / 100),
                detailText: nil)
        case .completed(let state):
            return (
                text: text,
                progress: nil,
                detailText: state)
        }
    }
}
