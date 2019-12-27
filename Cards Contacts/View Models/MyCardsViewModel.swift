//
//  MyCardsViewModel.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/24/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import RealmSwift

protocol MyCardsDelegte {
    func cardsListUpdated()
}

class MyCardsViewModel {
    
    var delegate: MyCardsDelegte?
    private var cardList = CardList()
    private var isFavouriteSelected = false
    
    init () {
        updateCards()
    }
        
    func numberOfRows(_ section: Int) -> Int {
        return self.cardList.cards.count
    }
    
    func modelAt(_ index: Int) -> Card {
        return self.cardList.cards[index]
    }
    
    func getCards() -> [Card]{
        return cardList.cards
    }
    
    func getIsFavouriteSelected() -> Bool {
        return isFavouriteSelected
    }
    
    func toggleFavourite() -> Bool {
        self.isFavouriteSelected = !self.isFavouriteSelected
        return self.isFavouriteSelected
    }
    
    func updateCards () {
        self.retrieveCards()
        
        CardsWebService().getDocument(objectType: CardList.self, collectionName: CardsWebService.CARDS_LIST_COLLECTION_NAME) { cardList in
            self.storeCards(cards: cardList.cards)
            self.retrieveCards()
        }
    }
    
    private func storeCards(cards: [Card]) {
        let storageService = StorageService()
        cards.forEach { card in
            storageService.storeObject(object: card)
        }
    }
    
    private func retrieveCards() {
        let storageService = StorageService()
        let cards = storageService.retrieveObject(objectType: Card.self)
        if let cards = cards {
            let cardList = CardList(cards: Array(cards))
            self.cardList = cardList
            self.delegate?.cardsListUpdated()
        }
    }
}
