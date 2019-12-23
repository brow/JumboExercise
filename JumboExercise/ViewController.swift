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
            ProgressCell.self,
            forCellReuseIdentifier: ProgressCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRowsTo(_ rows: [(Operation.ID, Operation.State)]) {
        self.rows = rows
        tableView.reloadData()
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
        let model = rows[indexPath.row]
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

class ProgressCell: UITableViewCell {
    static let reuseIdentifier = "Cell"
    
    private let progressView: UIProgressView
    
    func setProgress(_ progress: Float?) {
        if let progress = progress {
            accessoryView = progressView
            progressView.progress = progress
        } else {
            accessoryView = nil
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        progressView = UIProgressView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: 100,
                    // Acutual height is determined by `.progressViewStyle`.
                    height: 0)))
        
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        accessoryView = progressView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
