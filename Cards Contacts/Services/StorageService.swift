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
    
    func removeObject<T : Object>(object: T) {
        if let realm = self.realm {
            do {
                try realm.write {
                    realm.delete(object)
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func removeObject<T : Object>(object: T, with key: String) {
        if let realm = self.realm {
            do {
                try realm.write {
                    if let objectToDelete = realm.object(ofType: T.self, forPrimaryKey: key) {
                          realm.delete(objectToDelete)
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func writeData(customWrite: () -> ()) {
        if let realm = self.realm {
            do {
                try realm.write {
                    customWrite()
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
    
    func retrieveObject<T : Object>(objectType: T.Type, with predicate: NSPredicate) -> Results<T>? {
        if let realm = self.realm {
            let objects = realm.objects(objectType).filter(predicate)
            return objects
        }
        return nil
    }
    
    static func migrateVersion() {
        print("Realm \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "none found")" )
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in

            })
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        do {
            _ = try Realm()
        } catch let error as NSError {
            print(error)
        }
    }
}
