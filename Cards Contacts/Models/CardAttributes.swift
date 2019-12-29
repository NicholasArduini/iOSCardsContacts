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
    
    var fieldItemList = List<FieldItemList>()
    @objc dynamic var altName : String? = nil
    @objc dynamic var uid : String = ""
    
    enum CodingKeys: String, CodingKey {
        case fieldItemList
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
        
        // use superDecoder() to pass uid to custom FieldItemList decoder
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .fieldItemList)
        while !dataContainer.isAtEnd {
            let nestedDecoder = try dataContainer.superDecoder()
            let fieldItemArray = try FieldItemList(from: nestedDecoder, uid: self.uid)
            fieldItemList.append(fieldItemArray)
        }
    }
    
    override public static func primaryKey() -> String? {
        return "uid"
    }
}

public class FieldItemList: Object, Decodable {
    
    var fieldItems = List<FieldItem>()
    @objc dynamic var fieldName: String = ""
    @objc dynamic var compoundKey = ""
    @objc dynamic var uid : String = ""
    
    enum CodingKeys: String, CodingKey {
        case fieldItems
        case fieldName
    }
    
    required convenience public init(from decoder: Decoder, uid: String) throws {
        self.init()
        self.uid = uid
        try decode(from: decoder)
        self.compoundKey = compoundKeyValue()
    }
    
    private func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fieldName = try container.decode(String.self, forKey: .fieldName)
        
        // use superDecoder() to pass uid to custom FieldItem decoder
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .fieldItems)
        while !dataContainer.isAtEnd {
            let nestedDecoder = try dataContainer.superDecoder()
            let fieldArray = try FieldItem(from: nestedDecoder, uid: self.uid)
            fieldItems.append(fieldArray)
        }
    }
    
    func compoundKeyValue() -> String {
        return "\(uid)\(fieldName)"
    }
    
    override public static func primaryKey() -> String? {
        return "compoundKey"
    }
}

enum FieldType: String, Decodable {
    case number, email
}

public class FieldItem: Object, Decodable {
    
    @objc dynamic var fieldName: String = ""
    @objc dynamic var value: String = ""
    @objc dynamic var typeString: String = FieldType.number.rawValue
    var type: FieldType {
        get{
            FieldType(rawValue: typeString) ?? .number
        }
    }
    @objc dynamic var compoundKey = ""
    @objc dynamic var uid : String = ""
    
    enum CodingKeys: String, CodingKey {
        case fieldName
        case value
        case typeString = "type"
    }
    
    private func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        typeString = try container.decode(String.self, forKey: .typeString)
        fieldName = try container.decode(String.self, forKey: .fieldName)
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
        return "\(uid)\(fieldName)\(value)"
    }
    
    override public static func primaryKey() -> String? {
        return "compoundKey"
    }
}
