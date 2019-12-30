//
//  ForgotPasswordViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/30/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class ForgoutPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
        
    override func viewDidLayoutSubviews() {
        self.setupView()
    }
    
    func setupView() {
        emailTextField.makeTextFieldUnderline()
        
        resetPasswordButton.makeRounded()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        self.resetPasswordButton.loadingIndicator(true)
        if let email = emailTextField.text {
            AuthService(self).forgotPassword(email: email, onSuccess: {
                self.resetPasswordButton.loadingIndicator(false)
                self.dismiss(animated: true, completion: nil)
            }, onFailure: {
                self.resetPasswordButton.loadingIndicator(false)
            })
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
