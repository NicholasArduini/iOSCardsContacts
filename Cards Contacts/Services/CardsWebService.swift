//
//  CardsWebService.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/26/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CardsWebService {
    
    public static let CARDS_LIST_COLLECTION_NAME = "cards-list"
    public static let USER_CARDS_COLLECTION_NAME = "user-cards"
    
    let db : Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func getDocument<T : Decodable>(objectType: T.Type, collectionName: String, documentName: String, completion: @escaping (T) -> ()) {
        let docRef = db.collection(collectionName).document(documentName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    if let cards = document.data() {
                        let json = try JSONSerialization.data(withJSONObject: cards)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedObj = try decoder.decode(objectType.self, from: json)
                        
                        completion(decodedObj)
                    }
                } catch {
                    print(error)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
