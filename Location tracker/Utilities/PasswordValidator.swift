//
//  PasswordValidator.swift
//  Location tracker
//
//  Created by Ivan Solohub on 19.05.2025.
//

import Foundation

final class PasswordValidator {
    
    static func validatePasswordChange(
        current: String,
        new: String,
        confirm: String
    ) -> Result<Void, PasswordValidationErrors> {
        
        guard !current.isEmpty, !new.isEmpty, !confirm.isEmpty else {
            return .failure(.emptyFields)
        }
        
        guard new == confirm else {
            return .failure(.passwordsDoNotMatch)
        }
        
        guard new.count >= 6 else {
            return .failure(.passwordTooShort)
        }
        
        guard !new.contains(" ") else {
            return .failure(.passwordContainsSpaces)
        }
        
        return .success(())
    }
}
