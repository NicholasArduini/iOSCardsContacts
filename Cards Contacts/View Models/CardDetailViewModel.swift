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
    private var cardAttributes = CardAttributes()
    
    private var cardUid : String?
    
    init (cardUid: String) {
        self.cardUid = cardUid
        updateCardDetails()
    }
    
    func numberOfSections() -> Int {
        return self.cardAttributes.fieldItemList.count
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return self.cardAttributes.fieldItemList[section].fieldItems.count
    }
    
    func modelAt<FieldItem>(_ section: Int, _ index: Int) -> FieldItem {
        let fieldItemList = self.cardAttributes.fieldItemList[section]
        let fieldItem = fieldItemList.fieldItems[index]
        
        return fieldItem as! FieldItem
    }
    
    func getCardAttributes() -> CardAttributes{
        return cardAttributes
    }
    
    func updateCardDetails () {
        self.retrieveCardDetails()
        if let cardUid = self.cardUid {
            CardsWebService().getDocument(objectType: CardAttributes.self, collectionName: CardsWebService.USER_CARDS_COLLECTION_NAME, documentName: cardUid) { cardAttributes in
                self.storeCardDetails(cardAttrs: cardAttributes)
                self.retrieveCardDetails()
            }
        }
    }
    
    private func storeCardDetails(cardAttrs: CardAttributes) {
        let storageService = StorageService()
        storageService.storeObject(object: cardAttrs)
    }
    
    private func retrieveCardDetails() {
        let storageService = StorageService()
        let predicate = NSPredicate(format: "uid = %@", cardUid ?? "")
        let cardAttributes = storageService.retrieveObject(objectType: CardAttributes.self, with: predicate)
        if let firstCardAttributes = cardAttributes?.first {
            self.cardAttributes = CardAttributes(value: firstCardAttributes)
            self.delegate?.cardDetailsUpdated()
        }
    }
}
