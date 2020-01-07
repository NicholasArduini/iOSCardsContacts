//
//  Enodeable+Extension.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 1/2/20.
//  Copyright © 2020 Nicholas Arduini. All rights reserved.
//

import Foundation


extension Encodable {

    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
