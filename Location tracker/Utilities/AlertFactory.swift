//
//  AlertFactory.swift
//  Location tracker
//
//  Created by Ivan Solohub on 14.05.2025.
//

import UIKit

final class AlertFactory {
    
    static func showTemporaryAlert(on viewController: UIViewController, message: String, duration: TimeInterval = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        viewController.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    static func showSimpleAlertWithOK(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppConstants.AlertFactory.oKButtonText, style: .default))
        viewController.present(alert, animated: true)
    }
    
    static func showSettingsAlert(on viewController: UIViewController,
                                  title: String = AppConstants.AlertFactory.settingsAlertTitleText,
                                  message: String = AppConstants.AlertFactory.settingsAlertMessageText) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: AppConstants.AlertFactory.cancelButtonText, style: .cancel))

        alert.addAction(UIAlertAction(title: AppConstants.AlertFactory.settingsButtonText, style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))

        viewController.present(alert, animated: true)
    }
    
    static func showChangePasswordAlert(on viewController: UIViewController, completion: @escaping (_ currentPassword: String, _ newPassword: String, _ confirmPassword: String) -> Void) {
        
        let alertController = UIAlertController(
            title: AppConstants.AlertFactory.changePassAlertTitleText,
            message: nil,
            preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = AppConstants.AlertFactory.enterCurrentPassTFPlaceholderText
            textField.isSecureTextEntry = true
            textField.delegate = UITextField.noSpacesDelegate
        }

        alertController.addTextField { textField in
            textField.placeholder = AppConstants.AlertFactory.enterNewPassTFPlaceholderText
            textField.isSecureTextEntry = true
            textField.delegate = UITextField.noSpacesDelegate
        }

        alertController.addTextField { textField in
            textField.placeholder = AppConstants.AlertFactory.confirmNewPassTFPlaceholderText
            textField.isSecureTextEntry = true
            textField.delegate = UITextField.noSpacesDelegate
        }

        let confirmAction = UIAlertAction(
            title: AppConstants.AlertFactory.changeButtonText,
            style: .default
        ) { _ in
            let currentPassword = alertController.textFields?[0].text ?? ""
            let newPassword = alertController.textFields?[1].text ?? ""
            let confirmPassword = alertController.textFields?[2].text ?? ""
            
            completion(currentPassword, newPassword, confirmPassword)
        }

        let cancelAction = UIAlertAction(
            title: AppConstants.AlertFactory.cancelButtonText,
            style: .cancel
        )

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true)
    }
    
    static func showLocationPermissionAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: AppConstants.AlertFactory.locationPermissionAlertTitleText,
            message: AppConstants.AlertFactory.locationPermissionAlertMessageText,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: AppConstants.AlertFactory.cancelButtonText, style: .cancel))

        alert.addAction(UIAlertAction(title: AppConstants.AlertFactory.settingsButtonText, style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))

        viewController.present(alert, animated: true)
    }
}
