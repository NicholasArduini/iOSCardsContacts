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
    
    var cardsSectionTitles = [String]()
    private var cardsDictionary = [String: [Card]]()
    private var filteredCardList = CardList()
    private var unfilteredCardList = CardList()
    private var isFavouriteSelected = false
    
    init () {
        updateCards()
    }
    
    func numberOfSections() -> Int {
        return cardsSectionTitles.count
    }
    
    func getSectionIndexTitles() -> [String] {
        return cardsSectionTitles
    }
    
    func numberOfRows(_ section: Int) -> Int {
        let cardKey = cardsSectionTitles[section]
        if let cardValues = cardsDictionary[cardKey] {
            return cardValues.count
        }
        return 0
    }
    
    func modelAt<Card>(_ section: Int, _ index: Int) -> Card {
        return getCard(for: IndexPath(row: index, section: section)) as! Card
    }
    
    func getCard(for indexPath: IndexPath) -> Card? {
        let cardKey = cardsSectionTitles[indexPath.section]
        let cardValues = cardsDictionary[cardKey]
        return cardValues?[indexPath.row]
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
        
        CardsWebService().getDocument(objectType: CardList.self, collectionName: CardsWebService.CARDS_LIST_COLLECTION_NAME, documentName: AuthService.getCurrentUserUID()) { cardList in
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
            setupSections()
            self.delegate?.cardsListUpdated()
        }
    }
    
    func filterCards(from string: String){
        if string.isEmpty {
            filteredCardList = unfilteredCardList
        }  else {
            filteredCardList.cards = unfilteredCardList.cards.filter { card in
                return card.name.lowercased().contains(string.lowercased())
            }
        }
        // have sections updated with newly filtered cards
        setupSections()
    }
    
    private func setupSections() {
        // clear sections
        cardsSectionTitles.removeAll()
        cardsDictionary.removeAll()
        
        /*
        go through all cards, if first letter index doesn't exist
        create it with one entry, else append to existing
         */
        for card in filteredCardList.cards {
            let cardKey = String(card.name.prefix(1))
                if var cardValues = cardsDictionary[cardKey] {
                    cardValues.append(card)
                    cardsDictionary[cardKey] = cardValues
                } else {
                    cardsDictionary[cardKey] = [card]
                }
        }
        
        // sort titles
        cardsSectionTitles = [String](cardsDictionary.keys)
        cardsSectionTitles = cardsSectionTitles.sorted(by: { $0 < $1 })
        
    }
}
