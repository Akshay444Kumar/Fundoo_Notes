//
//  UpdateNoteViewController.swift
//  CustomLogin
//
//  Created by YE002 on 16/07/23.
//

import UIKit

class UpdateNoteViewController: UIViewController {
    
    @IBOutlet var editNoteTitle: UITextField!
    @IBOutlet var editNoteDescription: UITextField!
    var delegate: DataPassDelegate?
    var completion: ((String,String) -> Void)?
    
    var editNote: String?
    var editDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNoteTitle.text = editNote
        editNoteDescription.text = editDescription
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let title = editNoteTitle.text else {return}
        guard let description = editNoteDescription.text else {return}
        completion?(title,description)
    }
}
