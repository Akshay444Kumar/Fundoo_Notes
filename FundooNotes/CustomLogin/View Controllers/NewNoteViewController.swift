//
//  NewNoteViewController.swift
//  CustomLogin
//
//  Created by YE002 on 10/07/23.
//

import UIKit


class NewNoteViewController: UIViewController {
        
    @IBOutlet var noteTitle: UITextField!
    @IBOutlet var noteDescription: UITextField!
    var delegate: DataPassDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = noteTitle.text else {return}
        guard let description = noteDescription.text else {return}
        
        delegate?.dataPassing(title: title, description: description, uid: UUID().uuidString, isDeleted: false, hasReminder: false)
        navigationController?.popViewController(animated: true)
    }
}
