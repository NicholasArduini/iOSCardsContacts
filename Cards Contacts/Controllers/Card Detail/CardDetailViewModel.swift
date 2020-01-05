//
//  CardDetailViewModel.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation

protocol CardDetailDelegte {
    func cardDetailsUpdated()
    func failureUpdatingCard(message: String)
    func cardFavouriteUpdated()
    func followRequestComplete(error: Error?)
}

class CardDetailViewModel {
    
    private var cardFieldItemsDict = [String: [FieldItem]]()
    var cardsFieldTitles = [String]()
    var card = Card()
    var isFavourite : Bool?
    var isFollowed : Bool?
    private var cardUid : String?
    
    var delegate: CardDetailDelegte?
    
    init (cardUid: String, isMyProfile: Bool) {
        self.cardUid = isMyProfile ? AuthService.getCurrentUserUID() : cardUid
        self.retrieveAttributes()
    }
    
    init () {
        self.cardUid = AuthService.getCurrentUserUID()
        self.retrieveAttributes()
    }
    
    func retrieveAttributes() {
        self.retrieveIsFavourite()
        self.retrieveIsFriend()
    }
    
    func sendFavourite() {
        let card = CardSummaryItem(card: self.card)
        if let isFavourite = isFavourite {
            card.setFavourite(isFavourite)
        }
        CardsWebService().favouriteCard(card: card, complete: { cardSummaryItem, error in
            if let newCardSummaryItem = cardSummaryItem {
                self.isFavourite = newCardSummaryItem.isFavourite
                StorageService().storeObject(object: card)
            }
            self.delegate?.cardFavouriteUpdated()
        })
    }
    
    func sendFollowRequest() {
        CardsWebService().followRequestCard(card: CardSummaryItem(card: self.card), complete: { error in
            self.delegate?.followRequestComplete(error: error)
        })
    }
    
    func updateCardDetails () {
        self.retrieveCardDetails()
        if let cardUid = self.cardUid {
            CardsWebService().getUserCard(uid: cardUid, complete: { card, error in
                if let card = card {
                    StorageService().storeObject(object: card)
                    self.retrieveCardDetails()
                } else if let error = error {
                    self.delegate?.failureUpdatingCard(message: error.localizedDescription)
                }
            })
        }
    }
    
    private func retrieveCardDetails() {
        let predicate = NSPredicate(format: "uid = %@", cardUid ?? "")
        let card = StorageService().retrieveObject(objectType: Card.self, with: predicate)
        if let firstCard = card?.first {
            self.card = Card(value: firstCard)
            self.setupFieldSections()
            self.delegate?.cardDetailsUpdated()
        }
    }
    
    private func retrieveIsFavourite() {
        let predicate = NSPredicate(format: "uid = %@", cardUid ?? "")
        let cardSummaryItem = StorageService().retrieveObject(objectType: CardSummaryItem.self, with: predicate)
        if let firstCard = cardSummaryItem?.first {
            self.isFavourite = firstCard.isFavourite
            self.delegate?.cardFavouriteUpdated()
        }
    }
    
    private func retrieveIsFriend() {
        let predicate = NSPredicate(format: "uid = %@", cardUid ?? "")
        let cardSummaryItem = StorageService().retrieveObject(objectType: CardSummaryItem.self, with: predicate)
        if cardSummaryItem != nil && cardSummaryItem!.count > 0 {
            self.isFollowed = true
        } else {
            self.isFollowed = false
        }
    }
    
    private func setupFieldSections() {
        // clear sections
        cardsFieldTitles.removeAll()
        cardFieldItemsDict.removeAll()
        
        /*
        go through all field items, set title for type. if title hasn't been used before
        create it with one entry, else append to existing
         */
        for fieldItem in card.fieldItems {
            let title = fieldItem.getSectionString()
            if var fieldItems = cardFieldItemsDict[title] {
                fieldItems.append(fieldItem)
                cardFieldItemsDict[title] = fieldItems
            } else {
                cardFieldItemsDict[title] = [fieldItem]
            }
        }
        
        // sort titles
        cardsFieldTitles = [String](cardFieldItemsDict.keys)
        cardsFieldTitles = cardsFieldTitles.sorted(by: { $0 < $1 })
        
        // move other fields to end of list
        if let otherIndex = cardsFieldTitles.firstIndex(of: FieldItem.OTHER_TITLE) {
            let otherElement = cardsFieldTitles.remove(at: otherIndex)
            cardsFieldTitles.append(otherElement)
        }
        
    }
}

extension CardDetailViewModel : GenericTableViewDataSource {
    
    func numberOfSections() -> Int {
        return self.cardsFieldTitles.count
    }
    
    func numberOfRows(_ section: Int) -> Int {
        let key = cardsFieldTitles[section]
        if let value = cardFieldItemsDict[key] {
            return value.count
        }
        return 0
    }
    
    func modelAt<FieldItem>(_ section: Int, _ index: Int) -> FieldItem {
        let key = cardsFieldTitles[section]
        let values = cardFieldItemsDict[key]
        return values?[index] as! FieldItem
    }
    
}
