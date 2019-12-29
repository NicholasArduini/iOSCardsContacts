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
    func numberOfRows(_ section: Int) -> Int
    func modelAt<T>(_ section: Int, _ index: Int) -> T
}

class TableViewDataSource<CellType,ViewModel : GenericTableViewDataSource, Model>: NSObject, UITableViewDataSource where CellType: UITableViewCell {
    
    let cellIdentifier: String
    var viewModel: ViewModel
    let configureCell: (CellType, Model) -> ()
    
    init(cellIdentifier: String, viewModel: ViewModel, configureCell: @escaping (CellType, Model) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.viewModel = viewModel
        self.configureCell = configureCell
    }
    
    func updateItems(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
}
