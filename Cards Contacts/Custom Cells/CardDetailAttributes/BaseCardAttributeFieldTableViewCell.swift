//
//  BaseCardAttributeFieldTableViewCell.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 1/14/20.
//  Copyright © 2020 Nicholas Arduini. All rights reserved.
//

import UIKit

class BaseCardAttributeFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var parentView: UIView?
    var fieldItem : FieldItem?
    var actionPressed : ((_ fieldItem: FieldItem) -> ())?
    private var isCopying = false
        
    func setCell(fieldItem: FieldItem, view: UIView, actionPressed: @escaping (_ fieldItem: FieldItem) -> ()) {
        self.fieldItem = fieldItem
        self.parentView = view
        self.actionPressed = actionPressed
        
        actionButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(copyValuePressed)))
    }
    
    @IBAction func actionButton(_ sender: Any) {
        if let fieldItem = fieldItem {
            if let actionPressed = actionPressed {
                actionPressed(fieldItem)
            }
        }
    }
    
    @objc func copyValuePressed() {
        if (isCopying) {
            return
        }
        
        self.isCopying = true
        UIPasteboard.general.string = actionButton.titleLabel?.text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if let parentView = parentView {
            parentView.showToast(message: Constants.COPIED) {
                self.isCopying = false
            }
        }
    }
    
}
