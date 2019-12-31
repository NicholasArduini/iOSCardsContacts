//
//  AuthenticationService.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/24/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class AuthService {
    
    private weak var vc : UIViewController?
    
    init(_ vc: UIViewController) {
        self.vc = vc
    }
    
    init() {
    }
    
    static func getCurrentUserUID() -> String {
        // TODO change to actual identifier when data is ready
        return "Nicholas"
    }
    
    func signIn(email: String, password: String, onSuccess: @escaping () -> (), onFailure: @escaping () -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if(user != nil){ //sign in success
                onSuccess()
            } else {
                onFailure()
                if let error = error?.localizedDescription {
                    if let vc = self.vc {
                        vc.presentAlert(withMessage: error)
                    }
                }
            }
        })
    }
    
    func signUp(email: String, password: String, onSuccess: @escaping () -> (), onFailure: @escaping () -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if(user != nil){ //user created success
                onSuccess()
            } else {
                onFailure()
                if let error = error?.localizedDescription {
                    if let vc = self.vc {
                        vc.presentAlert(withMessage: error)
                    }
                }
            }
        })
    }
    
    func forgotPassword(email: String, onSuccess: @escaping () -> (), onFailure: @escaping () -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            if let error = error {
                onFailure()
                if let vc = self.vc {
                    vc.presentAlert(withMessage: error.localizedDescription)
                }
            } else {
                onSuccess()
            }
        })
    }
    
    func isLoggedIn(isLoggedIn: @escaping (Bool) -> ()) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if(user != nil){
                isLoggedIn(true)
            } else {
                isLoggedIn(false)
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func logout(onSuccess: @escaping () -> ()) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let error {
            print(error)
        }
    }
    
}
