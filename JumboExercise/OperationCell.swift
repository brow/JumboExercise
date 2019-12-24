//
//  OperationCell.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit

/// The visual representation of an operation in progress.
class OperationCell: UITableViewCell {
    static let reuseIdentifier = "ProgressCell"
    
    private let progressView: UIProgressView
    
    func setModel(_ model: OperationsViewModel.CellModel) {
        textLabel?.text = model.text
        detailTextLabel?.text = model.detailText
        
        if let progress = model.progress {
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
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
