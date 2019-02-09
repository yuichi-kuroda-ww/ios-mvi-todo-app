//
//  NotesEmptyView.swift
//  mvi-template
//
//  Created by Yuichi Kuroda on 2/7/19.
//  Copyright © 2019 WW. All rights reserved.
//

import UIKit

class NotesEmptyView: UIView {
    let messageLabel: UILabel
    
    init() {
        messageLabel = UILabel()
        
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        messageLabel.text = "You haven't created any notes yet."
        messageLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        addSubview(messageLabel)
    }
    
    func setupConstraints() {
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
}
