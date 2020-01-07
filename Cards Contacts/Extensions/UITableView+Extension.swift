//
//  UITableView+Extension.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 1/6/20.
//  Copyright © 2020 Nicholas Arduini. All rights reserved.
//

import UIKit

var tableLineSeperator : UITableViewCell.SeparatorStyle?

extension UITableView {

    func setEmptyMessage(message: String, imageName: String?) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageLabel = UILabel()
        messageLabel.text = message
        if #available(iOS 13.0, *) {
            messageLabel.textColor = .label
        } else {
            messageLabel.textColor = .darkText
        }
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.sizeToFit()
        messageLabel.center = view.center
        view.addSubview(messageLabel)
        
        if let imageName = imageName {
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            let imageSize: CGFloat = 50
            imageView.frame = CGRect(x: view.bounds.midX - imageSize/2, y: view.bounds.midY - imageSize - messageLabel.bounds.height, width: imageSize, height: imageSize)
            view.addSubview(imageView)
        }
        
        tableLineSeperator = self.separatorStyle
        self.backgroundView = view
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = tableLineSeperator ?? .none
    }
}
