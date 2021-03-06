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
    public static let EDIT : String = "Edit"
    public static let LOGOUT : String = "Logout"
    public static let FOLLOW_REQUEST : String = "Follow request"
    public static let CONFIRMATION : String = "Confirmation"
    public static let CANCEL : String = "Cancel"
    public static let CONFIRM : String = "Confirm"
    public static let CONFRIM_REMOVE_CARD : String = "Are you sure you would like to remove this card?"
    public static let EMPTY_CARD_MESSAGE : String = "No cards yet.\nTry searching and adding cards first!"
    public static let EMPTY_SEARCH_MESSAGE : String = "Search cards"
    
    // View Cells
    public static let BROWSE_CARDS_TABLE_CELL : String = "browseCardsTableCell"
    public static let CARD_DETAIL_TABLE_CELL : String = "cardDetailTableCell"
    public static let CARD_DETAIL_ADDRESS_TABLE_CELL : String = "cardDetailAddressTableCell"
    
    // NIBs
    public static let BROWSE_CARDS_TABLE_CELL_NIB : String = "BrowseCardsTableViewCell"
    
    // Segues
    public static let SHOW_CARD_DETAIL_SEGUE : String = "showCardDetailSegue"
    public static let SHOW_CARD_SEARCH_DETAIL_SEGUE : String = "showCardSearchDetailSegue"
    public static let SHOW_CARD_DETAIL_CONTAINER_SEGUE : String = "showCardDetailContainerSegue"
    public static let SHOW_CARD_SEARCH_DETAIL_CONTAINER_SEGUE : String = "showCardSearchDetailContainerSegue"
    
    // Notification Identifiers
    public static let CARD_UPDATED_NOTIFICATION : String = "CardUpdatedNotificationIdentifier"
    
    // Images
    public static let CARDS_LOGO_IMAGE : String = "cards"
    public static let STAR_FILLED_ICON_IMAGE : String = "starFilled"
    public static let STAR_OPENED_ICON_IMAGE : String = "starOpen"
    public static let LOGOUT_ICON_IMAGE : String = "logout"
    public static let USER_REMOVE_ICON_IMAGE : String = "userRemove"
    public static let SEARCH_IMAGE : String = "searchImage"
    
    // Storyboard IDs
    public static let MAIN_STORYBOARD : String = "Main"
    public static let MAIN_TAB_VC : String = "TabVC"
    public static let LOGIN_VC : String = "LoginVC"
}
