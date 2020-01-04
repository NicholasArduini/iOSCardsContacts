//
//  CardsWebService.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/26/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation

class CardsWebService {
    
    private let CARDS_LIST_COLLECTION_NAME = "cards-list"
    private let USER_CARDS_COLLECTION_NAME = "user-cards"
    
    let firebaseManager = FirebaseManager()
    
    func getCurrentUserCardList(complete: @escaping (CardSummaryList?, Error?) -> ()) {
        
        self.firebaseManager.getDocument(objectType: CardSummaryList.self,
                                         collectionName: CARDS_LIST_COLLECTION_NAME,
                                         documentName: AuthService.getCurrentUserUID(),
        complete: { cardList, error in
            complete(cardList, error)
        })
    }
    
    func getUserCard(uid: String,
                     complete: @escaping (Card?, Error?) -> ()) {
        
        self.firebaseManager.getDocument(objectType: Card.self,
                                         collectionName: USER_CARDS_COLLECTION_NAME,
                                         documentName: uid,
        complete: { cards, error in
            complete(cards, error)
        })
    }
    
    func searchUserCards(searchText: String,
                     complete: @escaping ([Card]?, Error?) -> ()) {
        
        if searchText.count <= 0 {
            complete([], nil)
            return
        }
        
        self.firebaseManager.searchCollection(objectType: Card.self,
                                           collectionName: USER_CARDS_COLLECTION_NAME,
                                           searchField: "name", searchText: searchText,
        complete: { card, error in
            complete(card, error)
        })
    }
    
    func followRequestCard(card: CardSummaryItem,
                            complete: (@escaping (Error?) -> ())) {
                
        if let cardDict = card.dict {
            self.firebaseManager.addArrayItem(collectionName: CARDS_LIST_COLLECTION_NAME,
                                           documentName: AuthService.getCurrentUserUID(),
                                           arrayName: "cards",
                                           fields: cardDict,
            complete: { error in
                if let error = error {
                    complete(error)
                } else {
                    complete(nil)
                }
            })
        }
    }
    
    func favouriteCard(card: CardSummaryItem,
                       complete: (@escaping (CardSummaryItem?, Error?) -> ())) {
        
        let oldCard = card.copy() as! CardSummaryItem
        let newCard = card
        newCard.flipFavourite()
        
        if let oldCardDict = oldCard.dict, let newCardDict = newCard.dict {
            self.firebaseManager.updateArrayItem(collectionName: CARDS_LIST_COLLECTION_NAME,
                                           documentName: AuthService.getCurrentUserUID(),
                                           arrayName: "cards",
                                           oldFields: oldCardDict,
                                           newFields: newCardDict,
            complete: { error in
                if let error = error {
                    complete(nil, error)
                } else {
                    complete(newCard, nil)
                }
            })
        }
    }
}
