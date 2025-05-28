//
//  ValidationManager.swift
//  Location tracker
//
//  Created by Ivan Solohub on 27.05.2025.
//

final class ValidationManager {
    
    static func validateLogin(email: String?, password: String?) -> Result<Void, LoginValidationError> {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            return .failure(.emptyFields)
        }
        
        guard email.contains("@"), email.contains(".") else {
            return .failure(.invalidEmailFormat)
        }
        
        return .success(())
    }
    
    static func validateSignUp(email: String?, password: String?, confirmPassword: String?) -> Result<Void, SignUpUserValidationError> {
        guard let email = email, !email.isEmpty, !email.contains(" ") else {
            return .failure(.emptyEmail)
        }

        return validatePassword(password, confirmPassword)
    }

    static func validatePassword(_ password: String?, _ confirmPassword: String?) -> Result<Void, SignUpUserValidationError> {
        guard let password = password, !password.isEmpty,
              let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            return .failure(.emptyFields)
        }

        guard password == confirmPassword else {
            return .failure(.passwordsDoNotMatch)
        }

        guard password.count >= 6 else {
            return .failure(.passwordTooShort)
        }

        guard !password.contains(" ") else {
            return .failure(.passwordContainsSpaces)
        }

        return .success(())
    }
    
}
