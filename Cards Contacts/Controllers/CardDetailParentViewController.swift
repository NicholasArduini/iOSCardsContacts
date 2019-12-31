//
//  CardDetailParentViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/30/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class CardDetailParentViewController: UIViewController {
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var uid : String?
    var isFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavTransparent()
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        self.isFavourite = !self.isFavourite
        if isFavourite {
            self.favouriteButton.image = UIImage(named: Constants.STAR_FILLED_IMAGE)
        } else {
            self.favouriteButton.image = UIImage(named: Constants.STAR_OPENED_IMAGE)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.SHOW_CARD_DETAIL_CONTAINER_SEGUE {
            if let vc = segue.destination as? CardDetailContainerViewController {
                vc.uid = self.uid
                vc.isMyProfile = false
            }
        }
    }
}
