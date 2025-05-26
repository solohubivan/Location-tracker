//
//  SignUpUserValidationError.swift
//  Location tracker
//
//  Created by Ivan Solohub on 14.05.2025.
//

import Foundation

enum SignUpUserValidationError: LocalizedError {
    case emptyFields
    case passwordsDoNotMatch
    case passwordTooShort
    case passwordContainsSpaces
    case emptyEmail

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Please fill in all fields."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        case .passwordTooShort:
            return "Password must be at least 6 characters."
        case .passwordContainsSpaces:
            return "Password must not contain spaces."
        case .emptyEmail:
            return "Email field must not be empty."
        }
    }
}
