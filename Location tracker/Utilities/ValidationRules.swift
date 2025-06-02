//
//  ValidationRules.swift
//  Location tracker
//
//  Created by Ivan Solohub on 02.06.2025.
//

import Foundation

enum ValidationRules: LocalizedError {
    case emptyFields
    case invalidEmailFormat
    case passwordsDoNotMatch
    case passwordTooShort
    case passwordContainsSpaces
    case emptyEmail
    
    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return AppConstants.ErrorDescription.emptyFields
        case .invalidEmailFormat:
            return AppConstants.ErrorDescription.invalidEmailFormat
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
