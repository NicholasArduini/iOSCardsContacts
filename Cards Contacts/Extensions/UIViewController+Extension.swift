//
//  UIViewController+Extensions.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 12/27/19.
//  Copyright © 2019 Nicholas Arduini. All rights reserved.
//

import UIKit

var vcSpinnerView : UIView?

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func makeNavTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func presentAlert(withMessage: String){
        let alert = UIAlertController(title: Constants.ALERT, message: withMessage, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.themeColor
        alert.addAction(UIAlertAction(title: Constants.OKAY, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentConfirmAlert(withMessage: String, confirm: @escaping () -> ()){
        let alert = UIAlertController(title: Constants.CONFIRMATION, message: withMessage, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: Constants.CANCEL, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: Constants.CONFIRM, style: UIAlertAction.Style.destructive, handler: { action in
            confirm()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
        indicatorView.startAnimating()
        indicatorView.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(indicatorView)
            onView.addSubview(spinnerView)
        }
        
        vcSpinnerView = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vcSpinnerView?.removeFromSuperview()
            vcSpinnerView = nil
        }
    }
    
    func presentCrossDissolveVC(storyboardId: String, destId: String) {
        let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: destId)
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
}
