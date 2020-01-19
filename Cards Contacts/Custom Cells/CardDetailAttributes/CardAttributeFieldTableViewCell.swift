//
//  CardAttributeFieldTableViewCell.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class CardAttributeFieldTableViewCell: BaseCardAttributeFieldTableViewCell {
    
    override func setCell(fieldItem: FieldItem, view: UIView, actionPressed: @escaping (_ fieldItem: FieldItem) -> ()) {
        super.setCell(fieldItem: fieldItem, view: view, actionPressed: actionPressed)
        fieldName.text = fieldItem.name
        actionButton.setTitle(fieldItem.value, for: .normal)
    }
    
}
