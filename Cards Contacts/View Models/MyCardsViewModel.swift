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

class MyCardsViewModel : GenericTableViewDataSource {
    
    var delegate: MyCardsDelegte?
    private var filteredCardList = CardList()
    private var unfilteredCardList = CardList()
    private var isFavouriteSelected = false
    
    init () {
        updateCards()
    }
    
    func filterCards(from string: String){
        if string.isEmpty {
            filteredCardList = unfilteredCardList
        }  else {
            filteredCardList.cards = unfilteredCardList.cards.filter { card in
                return card.name.lowercased().contains(string.lowercased())
            }
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return self.filteredCardList.cards.count
    }
    
    func modelAt<Card>(_ section: Int, _ index: Int) -> Card {
        return self.filteredCardList.cards[index] as! Card
    }
    
    func getCards() -> [Card]{
        return filteredCardList.cards
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
        
        // TODO should be current uid instead of nicholas
        CardsWebService().getDocument(objectType: CardList.self, collectionName: CardsWebService.CARDS_LIST_COLLECTION_NAME, documentName: "Nicholas") { cardList in
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
            self.unfilteredCardList = cardList
            self.filteredCardList = cardList
            self.delegate?.cardsListUpdated()
        }
    }
}
