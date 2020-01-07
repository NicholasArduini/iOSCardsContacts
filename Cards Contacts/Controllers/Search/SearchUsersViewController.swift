//
//  SearchUsersViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/31/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, SearchUsersDelegte {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchUsersViewModel = SearchUsersViewModel()
    private var datasource: TableViewDataSource<BrowseCardsTableViewCell,SearchUsersViewModel,Card>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        
        self.searchUsersViewModel.delegate = self
        self.datasource = TableViewDataSource(cellIdentifier: Constants.BROWSE_CARDS_TABLE_CELL, emptyMessage: Constants.EMPTY_SEARCH_MESSAGE, emptyImageName: Constants.SEARCH_IMAGE, viewModel: self.searchUsersViewModel) { cell, model in
            let cell: BrowseCardsTableViewCell = cell
            cell.setCell(card: model)
        }
        self.tableView.dataSource = self.datasource
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: Constants.BROWSE_CARDS_TABLE_CELL_NIB, bundle: nil), forCellReuseIdentifier: Constants.BROWSE_CARDS_TABLE_CELL)
    }
    
    func setupNavBar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func searchUsersUpdated() {
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchUsersViewModel.searchForCards(searchText: searchText)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let card = self.searchUsersViewModel.getCard(for: indexPath)
        performSegue(withIdentifier: Constants.SHOW_CARD_SEARCH_DETAIL_SEGUE, sender: card)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.SHOW_CARD_SEARCH_DETAIL_SEGUE {
            if let vc = segue.destination as? CardDetailViewController {
                let card = sender as? Card
                if let card = card {
                    vc.uid = card.uid
                    vc.cardDetailType = .searchCard
                }
            }
        }
    }
}
