//
//  ShowAlert.swift
//  GameApp
//
//  Created by Alperen Arıcı on 19.07.2021.
//

import UIKit

protocol ShowAlert {
    func showError(alertTitle: String, alertActionTitle: String, alertMessage: String, ownerVC: UIViewController)
}

extension ShowAlert {
    func showError(alertTitle: String, alertActionTitle: String, alertMessage: String, ownerVC: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertActionTitle,
            style: .default,
            handler: nil))
        ownerVC.present(alert, animated: true, completion: nil)
    }
}
