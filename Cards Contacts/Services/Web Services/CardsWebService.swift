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
    
    let networkingManager = NetworkingManager()
    
    func getCurrentUserCardList(onSuccess: @escaping (CardSummaryList) -> (),
                                onFailure: ((String) -> ())?) {
        
        self.networkingManager.getDocument(objectType: CardSummaryList.self,
                                           collectionName: CARDS_LIST_COLLECTION_NAME,
                                           documentName: AuthService.getCurrentUserUID(),
        onSuccess: { cardList in
            onSuccess(cardList)
        },
        onFailure: { errorString in
            if let onFailure = onFailure {
                onFailure(errorString)
            }
        })
    }
    
    func getUserCard(uid: String,
                     onSuccess: @escaping (Card) -> (),
                     onFailure: ((String) -> ())?) {
        
        self.networkingManager.getDocument(objectType: Card.self,
                                           collectionName: USER_CARDS_COLLECTION_NAME,
                                           documentName: uid,
        onSuccess: { cards in
            onSuccess(cards)
        },
        onFailure: { errorString in
            if let onFailure = onFailure {
                onFailure(errorString)
            }
        })
    }
    
    func searchUserCards(searchText: String,
                     onSuccess: @escaping ([Card]) -> (),
                     onFailure: ((String) -> ())?) {
        
        if searchText.count <= 0 {
            onSuccess([])
            return
        }
        
        self.networkingManager.searchCollection(objectType: Card.self,
                                           collectionName: USER_CARDS_COLLECTION_NAME,
                                           searchField: "name", searchText: searchText,
        onSuccess: { card in
            onSuccess(card)
        },
        onFailure: { errorString in
            if let onFailure = onFailure {
                onFailure(errorString)
            }
        })
    }
    
    func followRequestUser(uid: String,
                     onSuccess: @escaping ([Card]) -> (),
                     onFailure: ((String) -> ())?) {
        
    }
}
