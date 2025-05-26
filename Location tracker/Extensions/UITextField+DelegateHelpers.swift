//
//  UITextField+DelegateHelpers.swift
//  Location tracker
//
//  Created by Ivan Solohub on 19.05.2025.
//

import UIKit

extension UITextField {
    
    static var noSpacesDelegate: UITextFieldDelegate {
        return NoSpacesDelegate.shared
    }
    
    private class NoSpacesDelegate: NSObject, UITextFieldDelegate {
        static let shared = NoSpacesDelegate()
        
        private override init() { super.init() }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return !string.contains(" ")
        }
    }
}
