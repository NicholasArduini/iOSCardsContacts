//
//  CardDetailViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//


import UIKit
import MessageUI

class CardDetailViewController: UIViewController, UITableViewDelegate, CardDetailDelegte, MFMailComposeViewControllerDelegate {
    
    private let SECTION_HEADER_HEIGHT : CGFloat = 40
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var card : Card!
    private var cardDetailViewModel : CardDetailViewModel!
    private var datasource: TableViewDataSource<CardAttributeFieldTableViewCell,CardDetailViewModel,FieldItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavTransparent()
        self.setupHeader()
        
        self.cardDetailViewModel = CardDetailViewModel(cardUid: card.uid)
        self.cardDetailViewModel.delegate = self
        self.datasource = TableViewDataSource(cellIdentifier: Constants.CARD_DETAIL_TABLE_CELL, viewModel: self.cardDetailViewModel) { cell, model in
            let cell: CardAttributeFieldTableViewCell = cell
            
            cell.setCell(fieldItem: model, view: self.view) { fieldItem in
                if fieldItem.type == .number {
                    Common.makeCall(vc: self, phoneNumber: fieldItem.value)
                } else if fieldItem.type == .email {
                    Common.composeEmail(vc: self, email: fieldItem.value)
                }
            }
        }
        self.tableView.dataSource = self.datasource
        self.tableView.delegate = self
    }
    
    func setupHeader() {
        if let image = UIImage.generateCircleImageWithText(text: card.name.getInitials(), size: 120) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        nameLabel.text = card.name
    }
    
    func cardDetailsUpdated() {
        self.tableView.reloadData()
        if let altName = cardDetailViewModel.getCardAttributes().altName {
            usernameLabel.text = altName
            usernameLabel.isHidden = false
        } else {
            usernameLabel.isHidden = true
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.cardDetailViewModel.getCardAttributes().fieldItemList[section].fieldName
        let width = self.view.frame.size.width
        let view = Common.buildTableViewSectionHeader(title: title, height: SECTION_HEADER_HEIGHT, width: width, cornerRadius: 6)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SECTION_HEADER_HEIGHT
    }
    
}
