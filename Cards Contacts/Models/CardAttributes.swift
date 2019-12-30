//
//  CardAttributes.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import RealmSwift

public class CardAttributes: Object, Decodable {
    
    var fieldItems = List<FieldItem>()
    @objc dynamic var altName : String? = nil
    @objc dynamic var uid : String = ""
    
    enum CodingKeys: String, CodingKey {
        case fieldItems
        case altName
        case uid
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uid = try container.decode(String.self, forKey: .uid)
        if container.contains(.altName) {
            altName = try container.decode(String.self, forKey: .altName)
        }
        
        // use superDecoder() to pass uid to custom fieldItem decoder
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .fieldItems)
        while !dataContainer.isAtEnd {
            let nestedDecoder = try dataContainer.superDecoder()
            let fieldItem = try FieldItem(from: nestedDecoder, uid: self.uid)
            fieldItems.append(fieldItem)
        }
    }
    
    override public static func primaryKey() -> String? {
        return "uid"
    }
}

public class FieldItem: Object, Decodable {
    
    enum FieldType: String, Decodable {
        case number, email, other
    }
    
    @objc dynamic var name: String = ""
    @objc dynamic var value: String = ""
    @objc dynamic var typeString: String = FieldType.other.rawValue
    var type: FieldType {
        get{
            FieldType(rawValue: typeString) ?? .other
        }
    }
    @objc dynamic var compoundKey = ""
    @objc dynamic var uid : String = ""
    
    static let OTHER_TITLE = "Other"
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
        case typeString = "type"
    }
    
    private func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        typeString = try container.decode(String.self, forKey: .typeString)
        name = try container.decode(String.self, forKey: .name)
        value = try container.decode(String.self, forKey: .value)
        
        if type == .number {
            value = Common.formatPhoneNumber(phoneNumber: value)
        }
    }
    
    required convenience public init(from decoder: Decoder, uid: String) throws {
        self.init()
        self.uid = uid
        try decode(from: decoder)
        self.compoundKey = compoundKeyValue()
    }
    
    func compoundKeyValue() -> String {
        return "\(uid)\(name)\(value)"
    }
    
    override public static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    func getSectionString() -> String {
        var title = ""
        switch self.type {
        case .number:
            title = "Phone number"
        case .email:
            title = "Email"
        case .other:
            title = FieldItem.OTHER_TITLE
        }
        return title
    }
}
