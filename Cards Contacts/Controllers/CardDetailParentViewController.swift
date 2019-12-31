//
//  CardDetailParentViewController.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/30/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

class CardDetailParentViewController: UIViewController {
    
    var uid : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavTransparent()
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
