//
//  SignUpViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 6/23/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
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
        fullNameTextField.makeTextFieldUnderline()
        
        signUpButton.makeRounded()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        if !validateFields() { return }
        self.signUpButton.loadingIndicator(true)
        if let email = emailTextField.text, let password = passwordTextField.text, let fullName = fullNameTextField.text {
            
            AuthService(self).signUp(email: email, password: password, onSuccess: {
                // add user basic profile to user-cards collection
                UserWebService().addUserCardAccount(name: fullName, complete: { error in
                    if let error = error {
                        self.signUpButton.loadingIndicator(false)
                        self.presentAlert(withMessage: error.localizedDescription)
                    } else {
                        self.signUpButton.loadingIndicator(false)
                        self.presentCrossDissolveVC(storyboardId: Constants.MAIN_STORYBOARD, destId: Constants.MAIN_TAB_VC)
                    }
                })
            }, onFailure: {
                self.signUpButton.loadingIndicator(false)
            })
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func validateFields() -> Bool {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let fullNameIsEmpty = fullNameTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        var errorIssues = [String]()
        
        if (fullNameIsEmpty) {
            errorIssues.append("full name")
        }
        
        if (emailIsEmpty) {
            errorIssues.append("email name")
        }
        
        if (passwordIsEmpty) {
            errorIssues.append("password")
        }
        
        if !errorIssues.isEmpty {
            let message = "Please complete \(errorIssues.joined(separator: ", "))"
            self.presentAlert(withMessage: message)
        }
        
        return true
    }
}


