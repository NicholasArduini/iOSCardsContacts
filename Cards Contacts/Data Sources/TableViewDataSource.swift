//
//  TableViewDataSource.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/24/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

protocol GenericTableViewDataSource {
    func numberOfSections() -> Int
    func getSectionIndexTitles() -> [String]
    func numberOfRows(_ section: Int) -> Int
    func modelAt<T>(_ section: Int, _ index: Int) -> T
}

// handle optional methods
extension GenericTableViewDataSource {

    func getSectionIndexTitles() -> [String]{
        return []
    }
}

class TableViewDataSource<CellType,ViewModel : GenericTableViewDataSource, Model>: NSObject, UITableViewDataSource where CellType: UITableViewCell {
    
    let cellIdentifier: String
    var viewModel: ViewModel
    let configureCell: (CellType, Model) -> ()
    
    let emptyMessage: String?
    let emptyImageName: String?
    
    init(cellIdentifier: String, emptyMessage: String?, emptyImageName: String?, viewModel: ViewModel, configureCell: @escaping (CellType, Model) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.viewModel = viewModel
        self.configureCell = configureCell
        self.emptyMessage = emptyMessage
        self.emptyImageName = emptyImageName
    }
    
    func updateItems(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let emptyMessage = emptyMessage, self.viewModel.numberOfSections() == 0 {
            tableView.setEmptyMessage(message: emptyMessage, imageName: emptyImageName)
        } else {
            tableView.restore()
        }
        
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("Cell with identifier \(self.cellIdentifier) not found")
        }
        
        let vm : Model = self.viewModel.modelAt(indexPath.section, indexPath.row)
        self.configureCell(cell, vm)
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.getSectionIndexTitles()
    }
}
