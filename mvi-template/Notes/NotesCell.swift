//
//  NotesCell.swift
//  mvi-template
//
//  Created by Yuichi Kuroda on 2/6/19.
//  Copyright © 2019 WW. All rights reserved.
//

import UIKit

struct NoteCellViewModel {
    let note: Note
}

class NoteCell: UITableViewCell {
    let noteLabel: UILabel
    let borderView: UIView
    
    static let identifier: String = "NoteCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        noteLabel = UILabel()
        borderView = UIView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {        
        contentView.addSubview(noteLabel)
        
        borderView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        contentView.addSubview(borderView)
    }
    
    func setupConstraints() {
        for v in contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            noteLabel.centerYAnchor.constraint(equalTo: noteLabel.superview!.centerYAnchor),
            noteLabel.leftAnchor.constraint(equalTo: noteLabel.superview!.leftAnchor, constant: 40),
            
            borderView.bottomAnchor.constraint(equalTo: borderView.superview!.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1),
            borderView.leftAnchor.constraint(equalTo: borderView.superview!.leftAnchor, constant: 39),
            borderView.rightAnchor.constraint(equalTo: borderView.superview!.rightAnchor, constant: -20),
            ])
    }
    
    func setup(with noteCellViewModel: NoteCellViewModel) {
        noteLabel.text = noteCellViewModel.note.text
    }
}
