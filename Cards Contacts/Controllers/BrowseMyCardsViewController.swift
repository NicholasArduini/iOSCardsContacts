//
//  BrowseMyCardsViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 6/23/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class BrowseMyCardsViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, MyCardsDelegte {

    private var myCardsViewModel = MyCardsViewModel()
    private var datasource: TableViewDataSource<BrowseMyCardsTableViewCell,Card>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
    
        self.myCardsViewModel.delegate = self
        self.datasource = TableViewDataSource(cellIdentifier: Constants.MY_CARDS_TABLE_CELL, items: self.myCardsViewModel.getCards()) { cell, vm in
            cell.setCell(card: vm)
        }
        self.tableView.dataSource = self.datasource
    }
    
    func setupNavBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
                
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
            self.favouriteButton.image = UIImage(named: Constants.STAR_FILLED_IMAGE)
        } else {
            self.favouriteButton.image = UIImage(named: Constants.STAR_OPENED_IMAGE)
        }
    }
    
    func cardsListUpdated() {
        self.datasource.updateItems(self.myCardsViewModel.getCards())
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController)
    }
}
