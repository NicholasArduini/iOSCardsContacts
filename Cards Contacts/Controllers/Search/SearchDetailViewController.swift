//
//  SearchDetailViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/31/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    
    @IBOutlet weak var followRequestButton: UIBarButtonItem!
    
    var uid : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.makeNavTransparent()
    }
    
    @IBAction func followRequestButton(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.SHOW_CARD_SEARCH_DETAIL_CONTAINER_SEGUE {
            if let vc = segue.destination as? CardDetailContainerViewController {
                vc.uid = self.uid
                vc.isMyProfile = false
            }
        }
    }
}
