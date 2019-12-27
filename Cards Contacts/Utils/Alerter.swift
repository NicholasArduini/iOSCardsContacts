//
//  Alerter.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/24/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class Alerter {
    
    private weak var vc : UIViewController!
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func presentAlert(withMessage: String){
        let alert = UIAlertController(title: Constants.ALERT, message: withMessage, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.themeColor
        alert.addAction(UIAlertAction(title: Constants.OKAY, style: UIAlertAction.Style.default, handler: nil))
        self.vc.present(alert, animated: true, completion: nil)
    }
}
