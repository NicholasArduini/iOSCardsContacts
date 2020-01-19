//
//  FirebaseManager.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/31/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    
    let db : Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func getDocument<T : Decodable>(objectType: T.Type, collectionName: String, documentName: String, complete: @escaping (T?, Error?) -> ()) {
        let docRef = db.collection(collectionName).document(documentName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    if let cards = document.data() {
                        let json = try JSONSerialization.data(withJSONObject: cards)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedObj = try decoder.decode(objectType.self, from: json)
                        
                        complete(decodedObj, nil)
                    }
                } catch {
                    complete(nil, error)
                    print(error)
                }
            } else {
                let error = NSError(domain:"Document does not exist", code:0, userInfo:nil)
                complete(nil, error)
            }
        }
    }
    
    func searchCollection<T : Decodable>(objectType: T.Type, collectionName: String, searchField: String, searchText: String, complete: @escaping ([T]?, Error?) -> ()) {
        let docRef = db.collection(collectionName).whereField(searchField, isGreaterThanOrEqualTo: searchText).whereField(searchField, isLessThanOrEqualTo: searchText + "\u{f8ff}").limit(to: 20)
        
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
                complete(nil, error)
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
                        complete(nil, error)
                        print(error)
                        return
                    }
                }
                complete(objArray, nil)
            }
        }
    }
    
    func addArrayItem(collectionName: String, documentName: String, arrayName: String, fields: Any, complete: @escaping (Error?) -> ()) {
        
        db.collection(collectionName).document(documentName).updateData(
            [ arrayName: FieldValue.arrayUnion([fields]) ]
        ) { error in
            if let error = error {
                complete(error)
                print(error)
            } else {
                complete(nil)
            }
        }
    }
    
    func removeArrayItem(collectionName: String, documentName: String, arrayName: String, fields: Any, complete: @escaping (Error?) -> ()) {
        
        db.collection(collectionName).document(documentName).updateData(
            [ arrayName: FieldValue.arrayRemove([fields]) ]
        ) { error in
            if let error = error {
                complete(error)
                print(error)
            } else {
                complete(nil)
            }
        }
    }
    
    
    // limitations of Firebase require the deletion of the old item in the array and add the new one, in order to update
    func updateArrayItem(collectionName: String, documentName: String, arrayName: String, oldFields: Any, newFields: Any, complete: @escaping (Error?) -> ()) {
        
        self.removeArrayItem(collectionName: collectionName, documentName: documentName, arrayName: arrayName, fields: oldFields) { error in
            if let error = error {
                complete(error)
                print(error)
            } else {
                self.addArrayItem(collectionName: collectionName, documentName: documentName, arrayName: arrayName, fields: newFields) { error in
                    if let error = error {
                        complete(error)
                        print(error)
                    } else {
                        complete(nil)
                    }
                }
            }
        }
    }
    
}
