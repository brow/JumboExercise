//
//  ViewController.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    private var rows: [(Operation.ID, Operation.State)]
    
    init(rows: [(Operation.ID, Operation.State)]) {
        self.rows = rows
        
        super.init(style: .plain)
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellReuseIdentifier)
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath)
        cell.textLabel?.text = rows[indexPath.row].0
        return cell
    }
}

private let cellReuseIdentifier = "Cell"
