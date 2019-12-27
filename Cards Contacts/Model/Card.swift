//
//  Card.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/25/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import RealmSwift

struct CardList: Decodable {
    
    var cards = [Card]()
                
    enum CodingKeys: String, CodingKey {
        case cards
    }
    
}

public class Card: Object, Decodable {
    
    @objc dynamic var name: String
    @objc dynamic var number: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case number
    }
    
    override public static func primaryKey() -> String? {
        return "number"
    }
    
}
