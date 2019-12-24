//
//  ProgressCell.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {
    static let reuseIdentifier = "ProgressCell"
    
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
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
