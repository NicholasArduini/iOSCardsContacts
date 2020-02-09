# Cards Contacts 

## Overview
* Phone book for the modern day internet 
* Find your friends / colleagues and share common contact information (phone numbers, email addresses, social media usernames, dates, and locations)
* When your friend (or card) changes their number, email, address, etc you don't need to ask them and update your copy of their information. Once they have changed their profile and you will always know the latest
* Save favorites, search and discover other cards, and store all card data locally on your device for offline usage
* Current feature list includes
  - Save and filter favorites
  - Tap and hold contact info to copy, indicated with popup and haptic feedback
  - Search and discover other cards
  - Store all cards data locally on your device for offline usage
  - Support for native dark and light modes

## Architecture
* Developed in Swift 5
* Utilizing the Firebase BaaS platform
* Implement MVVM architectural pattern to keep controllers clean and manageable
* Realm local database is used to cache card data for quick loading and offline usage

## Future Work
* Save custom profile images to Firebase and Realm
* Detailed search
  - Ability to search by other contact fields
  - TableView swipe down to load more search results (pagination)
* Ability to edit all of your profile attributes
* Sync Firebase deletion of cards with Realm local storage
* Notifications when a user has request to follow you, which will allow to accept or decline
* Select permissions of each field wether it is public, friends, or individually requested
* Create a contact and calendar server to keep native apps up to date
  - CardDAV server for user contacts
  - CalDAV server for user dates such as birthdays
* Migration away from Firebase, mainly due to its cost and limitations
  - A few limitations currently include
    - Limited search functionality (using a work around to search for a name field inside object)
    - Storing relational data, to reduce duplicate information and server requests
    - Updating arrays of object requires the full object definition and for the client to delete and add new. This can be mitigated through Cloud Functions, but still not ideal
  - Considering alternative such as
    - Cloud computing services (AWS, GCP, Azure)
    - Realm Cloud
    
![alt tag](https://user-images.githubusercontent.com/14320184/72694518-3d715680-3b03-11ea-8098-32366f459310.gif)
![alt tag](https://user-images.githubusercontent.com/14320184/72694014-5aa52580-3b01-11ea-9b20-a2c0319770c9.PNG)
![alt tag](https://user-images.githubusercontent.com/14320184/72694010-5a0c8f00-3b01-11ea-8383-2cfeaa56f6bd.PNG)
![alt tag](https://user-images.githubusercontent.com/14320184/72694011-5a0c8f00-3b01-11ea-90c1-9c3ad2067068.PNG)
![alt tag](https://user-images.githubusercontent.com/14320184/72694012-5a0c8f00-3b01-11ea-9f9a-4009257e38a2.PNG)
![alt tag](https://user-images.githubusercontent.com/14320184/72694013-5aa52580-3b01-11ea-946f-53cfe219a75e.PNG)
