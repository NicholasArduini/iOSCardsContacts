//
//  ApiManager.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/31/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class NetworkingManager {
    
    let db : Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func getDocument<T : Decodable>(objectType: T.Type, collectionName: String, documentName: String, onSuccess: @escaping (T) -> (), onFailure: @escaping (String) -> ()) {
        let docRef = db.collection(collectionName).document(documentName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    if let cards = document.data() {
                        let json = try JSONSerialization.data(withJSONObject: cards)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedObj = try decoder.decode(objectType.self, from: json)
                        
                        onSuccess(decodedObj)
                    }
                } catch {
                    onFailure(error.localizedDescription)
                    print(error)
                }
            } else {
                let message = "Document does not exist"
                onFailure(message)
                print(message)
            }
        }
    }
    
    func searchCollection<T : Decodable>(objectType: T.Type, collectionName: String, searchField: String, searchText: String, onSuccess: @escaping ([T]) -> (), onFailure: @escaping (String) -> ()) {
        let docRef = db.collection(collectionName).whereField(searchField, isGreaterThanOrEqualTo: searchText).whereField(searchField, isLessThanOrEqualTo: searchText + "\u{f8ff}")
        
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                onFailure(error.localizedDescription)
            } else {
                var objArray = [T]()
                for document in querySnapshot!.documents {
                    do {
                        let json = try JSONSerialization.data(withJSONObject:  document.data())
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedObj = try decoder.decode(objectType.self, from: json)
                        objArray.append(decodedObj)
                        
                    } catch {
                        onFailure(error.localizedDescription)
                        print(error)
                        return
                    }
                }
                
                onSuccess(objArray)
            }
        }
    }
}
