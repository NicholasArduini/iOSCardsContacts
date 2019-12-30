//
//  SecondViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 6/23/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavTransparent()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        AuthService().logout() {
            if let storyboard = self.storyboard {
                let initialViewController = storyboard.instantiateViewController(withIdentifier: Constants.LOGIN_VC)
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                if let appDelegate = appDelegate {
                    appDelegate.window?.rootViewController = initialViewController
                }
            }
        }
    }
    
}
