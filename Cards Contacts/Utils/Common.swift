//
//  Common.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation
import UIKit

class Common {
    
    static func buildTableViewSectionHeader(title: String, height: CGFloat, width: CGFloat, cornerRadius: CGFloat) -> UIView {
        let headerView =  UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = .systemGray5
        } else {
            headerView.backgroundColor = .lightGray
        }
        headerView.layer.cornerRadius = cornerRadius
        
        let label = UILabel(frame: CGRect(x: height/2, y: 0, width: width - 20, height: height))
        label.text = title
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        headerView.addSubview(label)
        return headerView
    }
}
