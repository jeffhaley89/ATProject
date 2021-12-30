//
//  UIViewController+ATProject.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/27/21.
//

import UIKit

extension UIViewController {
    func displayLocationAlert() {
        let alert = UIAlertController(
            title: "Find restaurants near you",
            message: "Allow ATProject to use your location to show you nearby restaurants",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsURL = URL(string:UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        present(alert, animated: true)
    }
}
