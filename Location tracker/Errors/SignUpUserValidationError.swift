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
            return AppConstants.ErrorDescription.emptyFields2
        case .passwordsDoNotMatch:
            return AppConstants.ErrorDescription.passwordsDoNotMatch
        case .passwordTooShort:
            return AppConstants.ErrorDescription.passwordTooShort
        case .passwordContainsSpaces:
            return AppConstants.ErrorDescription.passwordContainsSpaces
        case .emptyEmail:
            return AppConstants.ErrorDescription.emptyEmail
        }
    }
}
