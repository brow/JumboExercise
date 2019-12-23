//
//  ViewController.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var rows: State {
        didSet { tableView.reloadData() }
    }
    
    init(rows: State) {
        self.rows = rows
        
        super.init(style: .plain)
        
        tableView.register(
            ProgressCell.self,
            forCellReuseIdentifier: ProgressCell.reuseIdentifier)
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
        return rows.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let model = rows.operationAtIndex(indexPath.row)
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: ProgressCell.reuseIdentifier,
                for: indexPath)
            as! ProgressCell
        
        cell.selectionStyle = .none
        cell.textLabel?.text = model.0
        
        switch model.1 {
        case .inProgress(let progress):
            cell.setProgress(Float(progress / 100))
            cell.detailTextLabel?.text = nil
        case .completed(let state):
            cell.setProgress(nil)
            cell.detailTextLabel?.text = state
        }
        
        return cell
    }
}

private let cellReuseIdentifier = "Cell"
