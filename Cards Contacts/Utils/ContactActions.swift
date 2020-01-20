//
//  ContactActions.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/31/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ContactActions {
    
    static func makeCall(vc: UIViewController, phoneNumber: String) {
        let url:NSURL? = NSURL(string: "tel://\(phoneNumber.filterOnlyNumbers())")
        
        if let url = url {
            if (UIApplication.shared.canOpenURL(url as URL)) {
                UIApplication.shared.open(url as URL)
                return
            }
        }
        
        vc.presentAlert(withMessage: Constants.COULD_NOT_CALL_NUMBER)
    }
    
    static func composeEmail(vc: UIViewController, email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([email])
            mail.mailComposeDelegate = vc as? MFMailComposeViewControllerDelegate
            vc.present(mail, animated: true)
        } else {
            vc.presentAlert(withMessage: Constants.COULD_NOT_COMPOSE_EMAIL)
        }
    }
    
    static func launchMap(address: String, pinName: String) {
        MapKitUtils.getLatLonFrom(address: address, onError: { _ in }, onSuccess: { lat, lon in
            MapKitUtils.launchOnMap(lat: lat, lon: lon, name: pinName)
        })
    }
}
