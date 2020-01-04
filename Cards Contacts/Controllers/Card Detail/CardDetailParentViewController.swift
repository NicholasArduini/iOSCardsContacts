//
//  CardDetailParentViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/30/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class CardDetailParentViewController: UIViewController {
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var cardSummaryItem : CardSummaryItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavTransparent()
        
        self.setup()
    }
    
    func setup() {
        self.setFavouriteButton()
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        self.favouriteButton.isEnabled = false
        self.setFavouriteButton()
        self.sendFavourite()
    }
    
    func sendFavourite() {
        if let card = cardSummaryItem {
            CardsWebService().favouriteCard(card: card, complete: { cardSummaryItem, error in
                if let newCardSummaryItem = cardSummaryItem {
                    self.cardSummaryItem = newCardSummaryItem
                    self.setFavouriteButton()
                }
                self.favouriteButton.isEnabled = true
            })
        }
    }
    
    func setFavouriteButton() {
        if let card = self.cardSummaryItem {
            if card.isFavourite {
                self.favouriteButton.image = UIImage(named: Constants.STAR_FILLED_IMAGE)
            } else {
                self.favouriteButton.image = UIImage(named: Constants.STAR_OPENED_IMAGE)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.SHOW_CARD_DETAIL_CONTAINER_SEGUE {
            if let vc = segue.destination as? CardDetailContainerViewController {
                vc.uid = self.cardSummaryItem?.uid
                vc.isMyProfile = false
            }
        }
    }
}
