//
//  NoteCollectionViewCell.swift
//  CustomLogin
//
//  Created by YE002 on 10/07/23.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    var cellIndex: IndexPath?
    var delegate: DataDeletionDelegate?
    var reminderDelegate: SetReminderDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Custom"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    private let setReminderButton: UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bell.circle"), for: UIControl.State.normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(setReminderButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.bin.circle.fill"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var note: Note?{
        didSet {
            print("Inside Did Set")
        }
        
        willSet {
            print("Inside Will Set")
        }
    }
    
    
    func set(note: Note) {
        titleLabel.text = note.title
        descriptionLabel.text = note.description
    }
    
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(setReminderButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        setReminderButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 22),
            
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            
            setReminderButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: 10),
            setReminderButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            setReminderButton.heightAnchor.constraint(equalToConstant: 50),
            setReminderButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func setReminderButtonTapped() {
        print("Set Reminder Tapped")
        reminderDelegate?.setReminder(index: cellIndex!.row)
    }
    
    
    @objc func deleteButtonTapped() {
        print("Delete Tapped")
        delegate?.deleteData(index: cellIndex!.row)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
