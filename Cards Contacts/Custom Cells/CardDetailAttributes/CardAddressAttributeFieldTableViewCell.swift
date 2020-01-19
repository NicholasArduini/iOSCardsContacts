//
//  CardAddressAttributeFieldTableViewCell.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 1/10/20.
//  Copyright © 2020 Nicholas Arduini. All rights reserved.
//

import UIKit
import MapKit

class CardAddressAttributeFieldTableViewCell: BaseCardAttributeFieldTableViewCell {
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func setCell(fieldItem: FieldItem, view: UIView, actionPressed: @escaping (_ fieldItem: FieldItem) -> ()) {
        super.setCell(fieldItem: fieldItem, view: view, actionPressed: actionPressed)
        fieldName.text = fieldItem.name
        
        setUI()
                
        if let value = fieldItem.addressValue {
            actionButton.setTitle(value.toUIString(), for: .normal)
            // temporary solution to fix button not filling spacing for wrapping words (i.e works for new lines)
            addressLabel.text = value.toUIString()
            
            MapKitUtils.getLatLonFrom(address: value.toString(), onError: { _ in }, onSuccess: { lat, lon in
                MapKitUtils.generateMapImageFrom(lat: lat, lon: lon, bounds: self.mapImageView.bounds, onError: { _ in }, onSuccess: { image in
                    self.mapImageView.image = image
                })
            })
        }
    }
    
    func setUI() {
        actionButton.titleLabel?.numberOfLines = 0;
        actionButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        actionButton.titleLabel?.lineBreakMode = .byWordWrapping;
        mapImageView.layer.cornerRadius = 4
        if #available(iOS 13.0, *) {
            self.mapImageView.backgroundColor = .systemGray5
        } else {
            self.mapImageView.backgroundColor = .gray
        }
    }
    
}
