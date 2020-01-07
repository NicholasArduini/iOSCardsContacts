//
//  BrowseMyCardsViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 6/23/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class BrowseMyCardsViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, MyCardsDelegte {

    private let SECTION_HEADER_HEIGHT : CGFloat = 30
    
    private var myCardsViewModel = MyCardsViewModel()
    private var datasource: TableViewDataSource<BrowseCardsTableViewCell,MyCardsViewModel,CardSummaryItem>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.addNotificationObservers()
    
        self.myCardsViewModel.delegate = self
        self.datasource = TableViewDataSource(cellIdentifier: Constants.BROWSE_CARDS_TABLE_CELL, emptyMessage: nil, emptyImageName: nil, viewModel: self.myCardsViewModel) { cell, model in
            let cell: BrowseCardsTableViewCell = cell
            cell.setCell(card: model)
        }
        self.tableView.register(UINib(nibName: Constants.BROWSE_CARDS_TABLE_CELL_NIB, bundle: nil), forCellReuseIdentifier: Constants.BROWSE_CARDS_TABLE_CELL)
        self.tableView.dataSource = self.datasource
        self.tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    deinit {
       self.removeNotifcationObservers()
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCardList(notification:)), name: Notification.Name(Constants.CARD_UPDATED_NOTIFICATION), object: nil)
    }
    
    func removeNotifcationObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.CARD_UPDATED_NOTIFICATION), object: nil)
    }
    
    func setupNavBar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
                
        let rectSize = CGRect(x: 0, y: 0, width: 140, height: 30)
        let logoContainer = UIView(frame: rectSize)
        let imageView = UIImageView(frame: rectSize)
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: Constants.CARDS_LOGO_IMAGE)
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        if myCardsViewModel.toggleFavourite() {
            self.favouriteButton.image = UIImage(named: Constants.STAR_FILLED_ICON_IMAGE)
        } else {
            self.favouriteButton.image = UIImage(named: Constants.STAR_OPENED_ICON_IMAGE)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.SHOW_CARD_DETAIL_SEGUE {
            if let vc = segue.destination as? CardDetailViewController {
                let card = sender as? CardSummaryItem
                if let card = card {
                    vc.uid = card.uid
                    vc.cardDetailType = .browseCard
                }
            }
        }
    }
    
    @objc func updateCardList(notification: Notification) {
        self.myCardsViewModel.retrieveCards()
    }
    
    
    // MARK: MyCardsDelegte methods
    
    func cardsListUpdated() {
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            myCardsViewModel.filterCards(from: searchText)
            tableView.reloadData()
        }
    }
    
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let card = self.myCardsViewModel.getCard(for: indexPath) {
            performSegue(withIdentifier: Constants.SHOW_CARD_DETAIL_SEGUE, sender: card)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.myCardsViewModel.cardsSectionTitles[section]
        let width = self.view.frame.size.width
        let view = Common.buildTableViewSectionHeader(title: title, height: SECTION_HEADER_HEIGHT, width: width, cornerRadius: 0)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SECTION_HEADER_HEIGHT
    }
}
