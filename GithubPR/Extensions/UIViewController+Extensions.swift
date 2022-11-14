//
//  UIViewController+Extensions.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit

extension UIViewController {
    /// This method is used as a helper method to show a quick alert with title and message
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message for the alert
    func showAlert(title: String?, message: String?) {
        let viewController = UIAlertController(title: title,
                                               message: title != message ? message : nil,
                                               preferredStyle: .alert)
        let action = UIAlertAction(title: LocalizedString.ok.localized, style: .default)
        viewController.addAction(action)
        if let popoverController = viewController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.permittedArrowDirections = []
        }
        present(viewController, animated: true)
    }
}
