//
//  LoginViewController.swift
//  CustomLogin
//
//  Created by YE002 on 06/07/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    
    func setUpElements() {
        
        // Hide the Error label
        errorLabel.alpha = 0
        
        // Style the Elements
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        // Validate Textfields
        
        // Create cleaned versions of the textfield
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                
                let containerController = ContainerController()
                
                self.view.window?.rootViewController = UINavigationController(rootViewController: containerController)
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
