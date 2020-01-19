//
//  UserWebService.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 1/19/20.
//  Copyright © 2020 Nicholas Arduini. All rights reserved.
//

import Foundation

class UserWebService {
    
    let firebaseManager = FirebaseManager()
    
    func addUserCardAccount(name: String,
                            complete: (@escaping (Error?) -> ())) {
                
        let uid = AuthService.getCurrentUserUID()
        self.firebaseManager.addDocument(collectionName: CardsWebService.USER_CARDS_COLLECTION_NAME,
                                       documentName: uid,
                                       data: ["name" : name, "uid" : uid],
        complete: { error in
            if let error = error {
                complete(error)
            } else {
                self.firebaseManager.addDocument(collectionName: CardsWebService.CARDS_LIST_COLLECTION_NAME,
                                               documentName: uid,
                                               data: ["cards" : []],
                complete: { error in
                    if let error = error {
                        complete(error)
                    } else {
                        complete(nil)
                    }
                })
            }
        })
    }
    
}
