//
//  CardAttributeFieldTableViewCell.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class CardAttributeFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var fieldItem : FieldItem?
    var actionPressed : ((_ fieldItem: FieldItem) -> ())?
    var parentView: UIView?
    
    private var isCopying = false
    
    func setCell(fieldItem: FieldItem, view: UIView, actionPressed: @escaping (_ fieldItem: FieldItem) -> ()) {
        self.fieldItem = fieldItem
        self.parentView = view
        self.actionPressed = actionPressed
        fieldName.text = fieldItem.fieldName
        actionButton.setTitle(fieldItem.value, for: .normal)
        
        actionButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(copyValuePressed)))
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
    
    @IBAction func actionButton(_ sender: Any) {
        if let fieldItem = fieldItem {
            if let actionPressed = actionPressed {
                actionPressed(fieldItem)
            }
        }
    }
}


