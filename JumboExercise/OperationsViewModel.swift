//
//  OperationsViewModel.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

/// A view model, in the MVVM sense, for displaying operations in progress.
protocol OperationsViewModel {
    /// The view model for an individual table cell.
    typealias CellModel = (
        text: String,
        detailText: String?,
        progress: Float?)
    
    /// The number of rows in the table view.
    var count: Int { get}
    
    /// The model for the table cell at the given index. The table view should
    /// have a single section.
    ///
    /// - Parameters:
    ///   - index: The index. Must be less than `count`.
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
