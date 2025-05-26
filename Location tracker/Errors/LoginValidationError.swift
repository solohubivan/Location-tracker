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
            return "Please enter both email and password."
        case .invalidEmailFormat:
            return "Invalid email format."
        }
    }
}
