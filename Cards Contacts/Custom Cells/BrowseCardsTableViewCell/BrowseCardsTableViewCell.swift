//
//  BrowseCardsTableViewCell.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/26/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class BrowseCardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setCell(card: CardSummaryItem) {
        nameLabel.text = card.name

        if let image = UIImage.generateCircleImageWithText(text: card.name.getInitials(), size: 48) {
            profileImage.image = image
        }
    }
    
    func setCell(card: Card) {
        nameLabel.text = card.name

        if let image = UIImage.generateCircleImageWithText(text: card.name.getInitials(), size: 48) {
            profileImage.image = image
        }
    }
}
