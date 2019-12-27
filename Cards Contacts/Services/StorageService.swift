//
//  StorageService.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import RealmSwift

class StorageService {
    
    let realm : Realm?
    
    init() {
        do {
            self.realm = try Realm()
        } catch let error as NSError {
            self.realm = nil
            print(error)
        }
    }
    
    func storeObject<T : Object>(object: T) {
        if let realm = self.realm {
            do {
                try realm.write {
                    realm.add(object, update: .modified)
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func retrieveObject<T : Object>(objectType: T.Type) -> Results<T>? {
        if let realm = self.realm {
            let objects = realm.objects(objectType)
            return objects
        }
        return nil
    }
}
