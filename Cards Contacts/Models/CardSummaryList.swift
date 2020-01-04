//
//  CardSummaryList.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/25/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import RealmSwift

struct CardSummaryList: Decodable {
    
    var cards = [CardSummaryItem]()
                
    enum CodingKeys: String, CodingKey {
        case cards
    }
}

public class CardSummaryItem: Object, Codable, NSCopying {
    
    @objc dynamic var name: String = ""
    @objc dynamic var uid: String = ""
    @objc dynamic var isFavourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case uid
        case isFavourite
    }
    
    func flipFavourite() {
        StorageService().writeData {
            isFavourite = !isFavourite
        }
    }
    
    init(name: String, uid: String, isFavourite: Bool) {
        self.name = name
        self.uid = uid
        self.isFavourite = isFavourite
    }

    required init() {
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = CardSummaryItem(name: name, uid: uid, isFavourite: isFavourite)
        return copy
    }
    
    override public static func primaryKey() -> String? {
        return "uid"
    }
    
}
