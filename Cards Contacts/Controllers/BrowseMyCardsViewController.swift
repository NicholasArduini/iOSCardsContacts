//
//  BrowseMyCardsViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 6/23/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class BrowseMyCardsViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, MyCardsDelegte {

    private var myCardsViewModel = MyCardsViewModel()
    private var datasource: TableViewDataSource<BrowseMyCardsTableViewCell,MyCardsViewModel,Card>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
    
        self.myCardsViewModel.delegate = self
        self.datasource = TableViewDataSource(cellIdentifier: Constants.MY_CARDS_TABLE_CELL, viewModel: self.myCardsViewModel) { cell, model in
            let cell: BrowseMyCardsTableViewCell = cell
            cell.setCell(card: model)
        }
        self.tableView.dataSource = self.datasource
        self.tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
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
            self.favouriteButton.image = UIImage(named: Constants.STAR_FILLED_IMAGE)
        } else {
            self.favouriteButton.image = UIImage(named: Constants.STAR_OPENED_IMAGE)
        }
    }
    
    func cardsListUpdated() {
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            myCardsViewModel.filterCards(from: searchText)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let card = self.myCardsViewModel.getCards()[indexPath.row]
        performSegue(withIdentifier: Constants.SHOW_CARD_DETAIL_SEGUE, sender: card)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.SHOW_CARD_DETAIL_SEGUE {
            if let vc = segue.destination as? CardDetailViewController {
                vc.card = sender as? Card
            }
        }
    }
    
}
