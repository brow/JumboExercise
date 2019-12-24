//
//  OperationsViewController.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit

/// A view controller that displays operations in progress.
class OperationsViewController: UITableViewController {
    
    /// The view model, in the sense of the MVVM architecture.
    var model: OperationsViewModel {
        didSet {
            // Individual table cells are not reactive to changes in the data,
            // so we must reload the table view when any data changes.
            //
            // Animations are not necessary because `model.count` is expected
            // never to change.
            tableView.reloadData()
        }
    }
    
    /// Initialize a view controller.
    ///
    /// - Parameters:
    ///   - model: The initial view model.
    init(model: OperationsViewModel) {
        self.model = model
        
        super.init(style: .plain)
        
        tableView.register(
            OperationCell.self,
            forCellReuseIdentifier: OperationCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int
    {
        return model.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: OperationCell.reuseIdentifier,
                for: indexPath)
            as! OperationCell
        cell.setModel(
            model.cellModelAtIndex(indexPath.row))
        return cell
    }
}
