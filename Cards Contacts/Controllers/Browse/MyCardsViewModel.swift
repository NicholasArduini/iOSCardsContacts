//
//  MyCardsViewModel.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/24/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation

protocol MyCardsDelegte: class {
    func cardsListUpdated()
}

class MyCardsViewModel {
    
    weak var delegate: MyCardsDelegte?
    
    var cardsSectionTitles = [String]()
    private var cardsDictionary = [String: [CardSummaryItem]]()
    private var filteredCardList = CardSummaryList()
    private var unfilteredCardList = CardSummaryList()
    private var isFavouriteSelected = false
    
    init () {
        updateCards()
    }
    
    func getCard(for indexPath: IndexPath) -> CardSummaryItem? {
        let cardKey = cardsSectionTitles[indexPath.section]
        let cardValues = cardsDictionary[cardKey]
        return cardValues?[indexPath.row]
    }
    
    func getIsFavouriteSelected() -> Bool {
        return isFavouriteSelected
    }
    
    func toggleFavourite() -> Bool {
        self.isFavouriteSelected = !self.isFavouriteSelected
        self.retrieveCards()
        return self.isFavouriteSelected
    }
    
    func updateCards () {
        self.retrieveCards()
        
        CardsWebService().getCurrentUserCardList() { [weak self] cardList, error in
            if let cardList = cardList {
                self?.storeCards(cards: cardList.cards)
                self?.retrieveCards()
            }
        }
    }
    
    private func storeCards(cards: [CardSummaryItem]) {
        let storageService = StorageService()
        cards.forEach { card in
            storageService.storeObject(object: card)
        }
    }
    
    func retrieveCards() {
        let cards = StorageService().retrieveObject(objectType: CardSummaryItem.self)
        if let cards = cards {
            let cardList = CardSummaryList(cards: Array(cards))
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
            // if favourite is selected, skip all those that aren't favourites
            if isFavouriteSelected && !card.isFavourite {
                continue
            }
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

extension MyCardsViewModel : GenericTableViewDataSource {
    
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
    
}
