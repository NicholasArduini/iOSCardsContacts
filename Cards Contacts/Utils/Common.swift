//
//  Common.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class Common {
    
    static func formatPhoneNumber(phoneNumber: String) ->String{
        if(phoneNumber.count >= 10){
            let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let middleStartIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let middleEndIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -4)
            let range = middleStartIndex..<middleEndIndex
            
            return "(\(phoneNumber[..<startIndex])) \(phoneNumber[range]) \(phoneNumber[middleEndIndex...])"
        } else {
            return phoneNumber
        }
    }
    
    static func makeCall(vc: UIViewController, phoneNumber: String) {
        let phoneNumber = phoneNumber.filter("0123456789.".contains)
        let url:NSURL? = NSURL(string: "tel://\(phoneNumber)")
        
        if let url = url {
            if (UIApplication.shared.canOpenURL(url as URL)) {
                UIApplication.shared.open(url as URL)
                return
            }
        }
        
        Alerter(vc: vc).presentAlert(withMessage: Constants.COULD_NOT_CALL_NUMBER)
    }
    
    static func composeEmail(vc: UIViewController, email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([email])
            mail.mailComposeDelegate = vc as? MFMailComposeViewControllerDelegate
            vc.present(mail, animated: true)
        } else {
            Alerter(vc: vc).presentAlert(withMessage: Constants.COULD_NOT_COMPOSE_EMAIL)
        }
    }
}
