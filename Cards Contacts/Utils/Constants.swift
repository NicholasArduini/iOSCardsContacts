//
//  Constants.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/24/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import Foundation

public struct Constants {
    
    //Alert messages
    public static let NOT_CONNECTED_TO_THE_INTERNET : String = "It looks like you are not connected to the internet"
    public static let COULD_NOT_COMPOSE_EMAIL : String = "Error trying to compose email"
    public static let COULD_NOT_CALL_NUMBER : String = "Error trying to call number"
    public static let ALERT : String = "Alert"
    public static let OKAY : String = "Okay"
    public static let COPIED : String = "Copied!"
    
    // View Cells
    public static let MY_CARDS_TABLE_CELL : String = "myCardsTableCell"
    public static let CARD_DETAIL_TABLE_CELL : String = "cardDetailTableCell"
    
    // Segues
    public static let LOGIN_TO_TAB_SEGUE : String = "loginToTabSegue"
    public static let SIGN_UP_TO_TAB_SEGUE : String = "signUpToTabSegue"
    public static let SHOW_CARD_DETAIL_SEGUE : String = "showCardDetailSegue"
    
    // Images
    public static let CARDS_LOGO_IMAGE : String = "cards"
    public static let STAR_FILLED_IMAGE : String = "starFilled"
    public static let STAR_OPENED_IMAGE : String = "starOpen"
    
    // Storyboard IDs
    public static let MAIN_STORYBOARD : String = "Main"
    public static let MAIN_TAB_VC : String = "TabVC"
    public static let LOGIN_VC : String = "LoginVC"
}
