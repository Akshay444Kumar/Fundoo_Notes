//
//  ProfileViewController.swift
//  CustomLogin
//
//  Created by YE002 on 28/07/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
    }
    
    private func getUserInfo() {
        NoteService.fetchUserProfile { user in
            // guard let user = user else { return }
            self.firstNameLabel.text = user?.firstName ?? ""
            self.lastNameLabel.text = user?.lastName ?? ""
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        print("Done Tapped")
        self.dismiss(animated: true)
    }
}
