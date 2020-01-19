//
//  String+Extension.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation

extension String {
    
    func getInitials() -> String {
        return self.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first ?? " ")") + "\($1.first ?? " ")" }
    }
    
    func filterOnlyNumbers() -> String {
        return self.filter("0123456789.".contains)
    }
    
    func formatAsPhoneNumber() ->String {
        if(self.count >= 10){
            let startIndex = self.index(self.startIndex, offsetBy: 3)
            let middleStartIndex = self.index(self.startIndex, offsetBy: 3)
            let middleEndIndex = self.index(self.endIndex, offsetBy: -4)
            let range = middleStartIndex..<middleEndIndex
            
            return "(\(self[..<startIndex])) \(self[range]) \(self[middleEndIndex...])"
        } else {
            return self
        }
    }
    
    func formatToSimpleDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
            return ""
        }
    }
}
