//
//  LoginValidationError.swift
//  Location tracker
//
//  Created by Ivan Solohub on 15.05.2025.
//

import Foundation

enum LoginValidationError: LocalizedError {
    case emptyFields
    case invalidEmailFormat

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return AppConstants.ErrorDescription.emptyFields
        case .invalidEmailFormat:
            return AppConstants.ErrorDescription.invalidEmailFormat
        }
    }
}
