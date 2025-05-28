//
//  PasswordValidationErrors.swift
//  Location tracker
//
//  Created by Ivan Solohub on 19.05.2025.
//

import Foundation

enum PasswordValidationErrors: LocalizedError {
    case emptyFields
    case passwordsDoNotMatch
    case passwordTooShort
    case passwordContainsSpaces

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return AppConstants.ErrorDescription.emptyFields2
        case .passwordsDoNotMatch:
            return AppConstants.ErrorDescription.passwordsDoNotMatch
        case .passwordTooShort:
            return AppConstants.ErrorDescription.passwordTooShort
        case .passwordContainsSpaces:
            return AppConstants.ErrorDescription.passwordContainsSpaces
        }
    }
}
