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
}

class CardDetailViewModel : GenericTableViewDataSource {
    
    var delegate: CardDetailDelegte?
    var cardsFieldTitles = [String]()
    private var cardFieldItemsDict = [String: [FieldItem]]()
    private var card = Card()
    
    private var cardUid : String?
    
    init (cardUid: String, isMyProfile: Bool) {
        self.cardUid = isMyProfile ? AuthService.getCurrentUserUID() : cardUid
        updateCardDetails()
    }
    
    init () {
        self.cardUid = AuthService.getCurrentUserUID()
        updateCardDetails()
    }
    
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
    
    func getCard() -> Card{
        return card
    }
    
    func updateCardDetails () {
        self.retrieveCardDetails()
        if let cardUid = self.cardUid {
            CardsWebService().getDocument(objectType: Card.self, collectionName: CardsWebService.USER_CARDS_COLLECTION_NAME, documentName: cardUid) { card in
                self.storeCardDetails(card: card)
                self.retrieveCardDetails()
            }
        }
    }
    
    private func storeCardDetails(card: Card) {
        let storageService = StorageService()
        storageService.storeObject(object: card)
    }
    
    private func retrieveCardDetails() {
        let storageService = StorageService()
        let predicate = NSPredicate(format: "uid = %@", cardUid ?? "")
        let card = storageService.retrieveObject(objectType: Card.self, with: predicate)
        if let firstCard = card?.first {
            self.card = Card(value: firstCard)
            self.setupFieldSections()
            self.delegate?.cardDetailsUpdated()
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
