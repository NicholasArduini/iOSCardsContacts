//
//  CardDetailTableViewSource.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 1/8/20.
//  Copyright © 2020 Nicholas Arduini. All rights reserved.
//

import UIKit

class CardDetailTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var cardDetailViewModel: CardDetailViewModel
    private var parentView: UIView
    private var actionPressed : ((_ fieldItem: FieldItem) -> ())
    
    init(cardDetailViewModel: CardDetailViewModel, view: UIView, actionPressed: @escaping ((_ fieldItem: FieldItem) -> ())) {
        self.cardDetailViewModel = cardDetailViewModel
        self.parentView = view
        self.actionPressed = actionPressed
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardDetailViewModel.numberOfRows(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cardDetailViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let fieldItem : FieldItem = self.cardDetailViewModel.modelAt(indexPath.section, indexPath.row)
        
        if fieldItem.addressValue != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CARD_DETAIL_ADDRESS_TABLE_CELL, for: indexPath) as? CardAddressAttributeFieldTableViewCell else {
                fatalError("\(Constants.CARD_DETAIL_ADDRESS_TABLE_CELL) not found")
            }
            cell.setCell(fieldItem: fieldItem, view: self.parentView, actionPressed: { fieldItem in
                self.actionPressed(fieldItem)
            })
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CARD_DETAIL_TABLE_CELL, for: indexPath) as? CardAttributeFieldTableViewCell else {
                fatalError("\(Constants.CARD_DETAIL_TABLE_CELL) not found")
            }
            cell.setCell(fieldItem: fieldItem, view: self.parentView, actionPressed: { fieldItem in
                self.actionPressed(fieldItem)
            })
            return cell
        }
    }
}
