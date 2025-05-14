//
//  UIViewController+KeyboardHandling.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit

extension UIViewController {
    
    func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
