//
//  UIView+Extension.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/28/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

extension UIView {
    
    func showToast(message : String, completion: @escaping () -> ()) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width/2 - 75, y: 50, width: 150, height: 35))
        if #available(iOS 13.0, *) {
            toastLabel.backgroundColor = UIColor.systemGray4
        } else {
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 12)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            completion()
        })
    }
    
}
