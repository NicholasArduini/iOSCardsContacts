//
//  CardDetailViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit
import MessageUI

enum CardDetailType {
    case myCard
    case browseCard
    case searchCard
}

class CardDetailViewController: UIViewController, UITableViewDelegate, CardDetailDelegte, MFMailComposeViewControllerDelegate {

    private let SECTION_HEADER_HEIGHT : CGFloat = 40
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    private var favouriteBarButton : UIBarButtonItem?
    private var removeCardBarButton : UIBarButtonItem?
    private var followRequestBarButton : UIBarButtonItem?
    private var logoutBarButton : UIBarButtonItem?
    private var editProfileBarButton : UIBarButtonItem?
    private var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    private var cardDetailViewModel : CardDetailViewModel!
    private var datasource: TableViewDataSource<CardAttributeFieldTableViewCell,CardDetailViewModel,FieldItem>!
    
    var cardDetailType : CardDetailType = .myCard
    var uid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = uid {
            self.cardDetailViewModel = CardDetailViewModel(cardUid: uid, isMyProfile: cardDetailType == .myCard)
        } else {
            self.cardDetailViewModel = CardDetailViewModel()
        }
        
        self.setupUI()
        
        self.cardDetailViewModel.delegate = self
        self.cardDetailViewModel.updateCardDetails()
        self.datasource = TableViewDataSource(cellIdentifier: Constants.CARD_DETAIL_TABLE_CELL, viewModel: self.cardDetailViewModel) { cell, model in
            let cell: CardAttributeFieldTableViewCell = cell
            
            cell.setCell(fieldItem: model, view: self.view) { fieldItem in
                if fieldItem.type == .number {
                    ContactActions.makeCall(vc: self, phoneNumber: fieldItem.value)
                } else if fieldItem.type == .email {
                    ContactActions.composeEmail(vc: self, email: fieldItem.value)
                }
            }
        }
        self.tableView.dataSource = self.datasource
        self.tableView.delegate = self
    }
    
    
    @objc func favouriteButtonClicked() {
        self.favouriteBarButton?.isEnabled = false
        self.setFavouriteButtonImage()
        self.cardDetailViewModel.sendFavourite()
    }
    
    @objc func removeUserButtonClicked() {
        self.presentConfirmAlert(withMessage: Constants.CONFRIM_REMOVE_CARD) {
            self.removeCardBarButton?.isEnabled = false
            self.cardDetailViewModel.removeUser { [weak self] error in
                guard let `self` = self else { return }
                if let error = error {
                    self.presentAlert(withMessage: error.localizedDescription)
                } else {
                    _ = self.navigationController?.popViewController(animated: true)
                    self.alertOnUpdateNotification()
                }
            }
        }
    }
    
    @objc func followRequestButton() {
        self.followRequestBarButton?.isEnabled = false
        self.cardDetailViewModel.sendFollowRequest { [weak self] error in
            guard let `self` = self else { return }
            if let error = error {
                self.followRequestBarButton?.isEnabled = true
                self.presentAlert(withMessage: error.localizedDescription)
            } else {
                self.cardDetailType = .browseCard
                self.setupNavBar()
                self.alertOnUpdateNotification()
            }
        }
    }
    
    @objc func logoutButton() {
        AuthService().logout() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeRootViewController(with: Constants.LOGIN_VC)
        }
    }
    
    func setupUI() {
        nameLabel.text = nil
        usernameLabel.text = nil
        setupNavBar()
        self.showSpinner(onView: self.view)
        self.makeNavTransparent()
    }
    
    func setupProfileHeader() {
        let card = self.cardDetailViewModel.card
        if let image = UIImage.generateCircleImageWithText(text: card.name.getInitials(), size: 120) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        nameLabel.text = card.name
    }
    
    func setFavouriteButtonImage() {
        if let isFavourite = cardDetailViewModel.isFavourite, isFavourite {
            self.favouriteBarButton?.image = UIImage(named: Constants.STAR_FILLED_IMAGE)
        } else {
            self.favouriteBarButton?.image = UIImage(named: Constants.STAR_OPENED_IMAGE)
        }
    }
    
    func setupNavBar() {
        // if you search your own profile show your profile page
        // else if you are following the searched user, show their profile as part of your cards
        if cardDetailViewModel.isMyProfile {
            self.cardDetailType = .myCard
        } else if let isFollowed = cardDetailViewModel.isFollowed, isFollowed {
            self.cardDetailType = .browseCard
        }
        
        switch cardDetailType {
        case .myCard:
            logoutBarButton = UIBarButtonItem(image: UIImage(named: Constants.LOGOUT_IMAGE), style: .plain, target: self, action: #selector(CardDetailViewController.logoutButton))
            editProfileBarButton = UIBarButtonItem(title: Constants.EDIT, style: .plain, target: self, action: nil)
            self.navigationItem.rightBarButtonItems = [logoutBarButton!, editProfileBarButton!]
        case .browseCard:
            favouriteBarButton = UIBarButtonItem(image: UIImage(named: Constants.STAR_OPENED_IMAGE), style: .plain, target: self, action: #selector(CardDetailViewController.favouriteButtonClicked))
            removeCardBarButton = UIBarButtonItem(image: UIImage(named: Constants.USER_REMOVE_IMAGE), style: .plain, target: self, action: #selector(CardDetailViewController.removeUserButtonClicked))
            self.navigationItem.rightBarButtonItems = [removeCardBarButton!, favouriteBarButton!]
            self.setFavouriteButtonImage()
        case .searchCard:
            followRequestBarButton = UIBarButtonItem(title: Constants.FOLLOW_REQUEST, style: .plain, target: self, action: #selector(CardDetailViewController.followRequestButton))
            self.navigationItem.rightBarButtonItems = [followRequestBarButton!]
        }
    }
    
    func alertOnUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(Constants.CARD_UPDATED_NOTIFICATION), object: nil)
    }
    
    // MARK: CardDetailDelegate methods
    
    func cardDetailsUpdated() {
        self.tableView.reloadData()
        self.setupProfileHeader()
        if let altName = cardDetailViewModel.card.altName {
            usernameLabel.text = altName
            usernameLabel.isHidden = false
        } else {
            usernameLabel.isHidden = true
        }
        self.removeSpinner()
    }
    
    func failureUpdatingCard(message: String) {
        self.removeSpinner()
        self.presentAlert(withMessage: message)
    }
    
    func cardFavouriteUpdated() {
        self.setFavouriteButtonImage()
        self.favouriteBarButton?.isEnabled = true
        self.alertOnUpdateNotification()
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.cardDetailViewModel.cardsFieldTitles[section]
        let width = self.view.frame.size.width
        let view = Common.buildTableViewSectionHeader(title: title, height: SECTION_HEADER_HEIGHT, width: width, cornerRadius: 6)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SECTION_HEADER_HEIGHT
    }
    
}
