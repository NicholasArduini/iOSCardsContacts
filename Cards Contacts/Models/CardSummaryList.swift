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

public class CardSummaryItem: Object, Decodable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var number: String = ""
    @objc dynamic var uid: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case number
        case uid
    }
    
    override public static func primaryKey() -> String? {
        return "uid"
    }
    
}
