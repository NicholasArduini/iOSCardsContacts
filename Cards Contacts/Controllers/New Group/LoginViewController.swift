//
//  LoginViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 6/23/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var logoImageTopContraint: NSLayoutConstraint!
    @IBOutlet weak var emailFieldToLogoImageTopContraint: NSLayoutConstraint!
    var defaultLogoContraint: CGFloat = 0
    
    override func viewDidLoad() {
        self.setupView()
        self.registerForKeyboardNotifications()
    }
    
    deinit {
        self.deregisterFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == emailTextField {
         passwordTextField.becomeFirstResponder()
      } else if textField == passwordTextField {
         textField.resignFirstResponder()
         login()
      }
     return true
    }
    
    func setupView() {
        //set underline for email and password textfields
        emailTextField.makeTextFieldUnderline()
        passwordTextField.makeTextFieldUnderline()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.makeRounded()
        self.hideKeyboardWhenTappedAround()
        self.defaultLogoContraint = CGFloat(self.logoImageTopContraint.constant)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    
    func login() {
        self.loginButton.loadingIndicator(true)
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthService(self).signIn(email: email, password: password, onSuccess: {
                self.loginButton.loadingIndicator(false)
                self.presentCrossDissolveVC(storyboardId: Constants.MAIN_STORYBOARD, destId: Constants.MAIN_TAB_VC)
            }, onFailure: {
                self.loginButton.loadingIndicator(false)
            })
        }
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.logoImageTopContraint.constant = 16
            self.emailFieldToLogoImageTopContraint.constant = 16
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.logoImageTopContraint.constant = self.defaultLogoContraint
            self.emailFieldToLogoImageTopContraint.constant = self.defaultLogoContraint
            self.view.layoutIfNeeded()
        }
    }
}
