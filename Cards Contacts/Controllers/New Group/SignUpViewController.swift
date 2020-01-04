//
//  SignUpViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 6/23/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
        
    override func viewDidLayoutSubviews() {
        self.setupView()
    }
    
    func setupView() {
        //set underline for email and password textfields
        emailTextField.makeTextFieldUnderline()
        passwordTextField.makeTextFieldUnderline()
        usernameTextField.makeTextFieldUnderline()
        
        signUpButton.makeRounded()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        self.signUpButton.loadingIndicator(true)
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService(self).signUp(email: email, password: password, onSuccess: {
                self.signUpButton.loadingIndicator(false)
                self.presentCrossDissolveVC(storyboardId: Constants.MAIN_STORYBOARD, destId: Constants.MAIN_TAB_VC)
            }, onFailure: {
                self.signUpButton.loadingIndicator(false)
            })
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


