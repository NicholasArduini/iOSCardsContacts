//
//  Card.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import RealmSwift

public class Card: Object, Decodable {
    
    var fieldItems = List<FieldItem>()
    @objc dynamic var name : String = ""
    @objc dynamic var altName : String? = nil
    @objc dynamic var uid : String = ""
    
    enum CodingKeys: String, CodingKey {
        case fieldItems
        case name
        case altName
        case uid
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        if container.contains(.altName) {
            altName = try container.decode(String.self, forKey: .altName)
        }
        
        // use superDecoder() to pass uid to custom fieldItem decoder
        let dataContainer = try? container.nestedUnkeyedContainer(forKey: .fieldItems)
        if var dataContainer = dataContainer {
            while !dataContainer.isAtEnd {
                let nestedDecoder = try dataContainer.superDecoder()
                let fieldItem = try FieldItem(from: nestedDecoder, uid: self.uid)
                fieldItems.append(fieldItem)
            }
        }
        
    }
    
    override public static func primaryKey() -> String? {
        return "uid"
    }
}


public class FieldItem: Object, Decodable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var value: String = ""
    @objc dynamic var addressValue: Address?
    @objc dynamic var typeString: String = FieldType.other.rawValue
    @objc dynamic var compoundKey = ""
    @objc dynamic var uid : String = ""
    
    static let OTHER_TITLE = "Other"
    
    var type: FieldType {
        get{
            FieldType(rawValue: typeString) ?? .other
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
        case typeString = "type"
    }
    
    private func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        typeString = try container.decode(String.self, forKey: .typeString)
        name = try container.decode(String.self, forKey: .name)
        if type == .address {
            addressValue = try container.decode(Address.self, forKey: .value)
        } else {
            value = try container.decode(String.self, forKey: .value)
        }

        formatFields()
    }
    
    required convenience public init(from decoder: Decoder, uid: String) throws {
        self.init()
        self.uid = uid
        try decode(from: decoder)
        self.compoundKey = compoundKeyValue()
    }
    
    func formatFields() {
        if type == .number {
            self.value = value.formatAsPhoneNumber()
        } else if type == .date {
            self.value = value.formatToSimpleDate()
        }
    }
    
    func compoundKeyValue() -> String {
        var key = "\(uid)\(name)"
        switch type {
        case .address:
            if let address = addressValue {
                key = "\(uid)\(name)\(address.toString())"
            }
        default:
            key = "\(uid)\(name)\(value)"
        }
        return key
    }
    
    override public static func primaryKey() -> String? {
        return "compoundKey"
    }
}


public class Address: Object, Decodable {
    @objc dynamic var street1: String = ""
    @objc dynamic var street2: String?
    @objc dynamic var city: String = ""
    @objc dynamic var province: String = ""
    @objc dynamic var zipcode: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var compoundKey = ""
    
    private enum CodingKeys: String, CodingKey {
        case street1
        case street2
        case city
        case province
        case zipcode
        case country
    }
    
    func toString() -> String {
        var addressString = "\(street1)"
        if let street2 = street2 {
            addressString.append(" \(street2)")
        }
        addressString.append("\(province) \(zipcode) \(country)")
        return addressString
    }
    
    func toUIString() -> String {
        var addressString = "\(street1)\n"
        if let street2 = street2 {
            addressString.append("\(street2)\n")
        }
        addressString.append("\(city) \(province) \(zipcode)\n\(country)")
        return addressString
    }
    
    private func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street1 = try container.decode(String.self, forKey: .street1)
        if container.contains(.street2) {
            street2 = try container.decode(String.self, forKey: .street2)
        }
        city = try container.decode(String.self, forKey: .city)
        province = try container.decode(String.self, forKey: .province)
        zipcode = try container.decode(String.self, forKey: .zipcode)
        country = try container.decode(String.self, forKey: .country)
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        try decode(from: decoder)
        self.compoundKey = toString()
    }
    
    override public static func primaryKey() -> String? {
        return "compoundKey"
    }
}


enum FieldType: String, Decodable, Comparable {
    case number, email, social, date, address, other
    
    private var sortOrder: Int {
        switch self {
            case .number:
                return 0
            case .email:
                return 1
            case .social:
                return 3
            case .address:
                return 4
            case .date:
                return 5
            case .other:
                return 6
        }
    }

     static func ==(lhs: FieldType, rhs: FieldType) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }

    static func <(lhs: FieldType, rhs: FieldType) -> Bool {
       return lhs.sortOrder < rhs.sortOrder
    }
    
    func getSectionString() -> String {
        var title = ""
        switch self {
        case .number:
            title = "Phone number"
        case .email:
            title = "Email"
        case .social:
            title = "Social Media"
        case .date:
            title = "Dates"
        case .address:
            title = "Address"
        case .other:
            title = FieldItem.OTHER_TITLE
        }
        return title
    }
}
