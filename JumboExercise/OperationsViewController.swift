//
//  OperationsViewController.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit

class OperationsViewController: UITableViewController {
    var model: OperationsViewModel {
        didSet { tableView.reloadData() }
    }
    
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
        let cellModel = model.cellModelAtIndex(indexPath.row)
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: OperationCell.reuseIdentifier,
                for: indexPath)
            as! OperationCell
        
        cell.textLabel?.text = cellModel.text
        cell.detailTextLabel?.text = cellModel.detailText
        cell.setProgress(cellModel.progress)

        return cell
    }
}

private let cellReuseIdentifier = "Cell"
