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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeRootViewController(with: Constants.LOGIN_VC)
        }
    }
}
