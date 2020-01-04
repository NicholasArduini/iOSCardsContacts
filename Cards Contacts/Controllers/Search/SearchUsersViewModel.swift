//
//  SearchUsersViewModel.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/31/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation

protocol SearchUsersDelegte {
    func searchUsersUpdated()
}

class SearchUsersViewModel : GenericTableViewDataSource {
    
    var delegate: SearchUsersDelegte?
    
    private var searchedCardList = [Card]()
    
    init () {
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return searchedCardList.count
    }
    
    func modelAt<Card>(_ section: Int, _ index: Int) -> Card {
        return searchedCardList[index] as! Card
    }
    
    func getCard(for indexPath: IndexPath) -> Card {
        return searchedCardList[indexPath.row]
    }
    
    func searchForCards (searchText: String) {
        CardsWebService().searchUserCards(searchText: searchText, complete: { cards, error in
            if let cards = cards {
                self.searchedCardList = cards
                self.delegate?.searchUsersUpdated()
            }
        })
    }
}
