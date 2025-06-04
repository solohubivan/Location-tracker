//
//  ValidationManagerTests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 04.06.2025.
//

import XCTest
@testable import Location_tracker

final class ValidationManagerTests: XCTestCase {
    
    func testValidateLoginWithValidCredentialsReturnsSuccess() {
        // Given
        let email = "ivan@example.com"
        let password = "123456"

        // When
        let result = ValidationManager.validateLogin(email: email, password: password)

        // Then
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success but got failure with error: \(error)")
        }
    }

    func testValidateLoginWithInvalidEmailFormatReturnsFailure() {
        // Given
        let email = "ivanexample.com"
        let password = "123456"

        // When
        let result = ValidationManager.validateLogin(email: email, password: password)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure due to invalid email format, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidEmailFormat)
        }
    }
    
    func testValidateLoginWithEmptyFieldsReturnsFailure() {
        // Given
        let email = ""
        let password = ""

        // When
        let result = ValidationManager.validateLogin(email: email, password: password)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure due to empty fields, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .emptyFields)
        }
    }
    
    func testValidateLoginWithEmptyEmailReturnsFailure() {
        // Given
        let email = ""
        let password = "123456"

        // When
        let result = ValidationManager.validateLogin(email: email, password: password)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure due to empty email, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .emptyFields)
        }
    }
    
    func testValidateLoginWithEmptyPasswordReturnsFailure() {
        // Given
        let email = "ivan@example.com"
        let password = ""

        // When
        let result = ValidationManager.validateLogin(email: email, password: password)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure due to empty password, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .emptyFields)
        }
    }
    
    func testValidateSignUpWithValidEmailOnlyReturnsSuccessFromPasswordValidation() {
        // Given
        let email = "ivan@example.com"
        let password = "password123"
        let confirmPassword = "password123"

        // When
        let result = ValidationManager.validateSignUp(email: email, password: password, confirmPassword: confirmPassword)

        // Then
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func testValidateSignUpWithEmptyEmailReturnsEmptyEmailError() {
        // Given
        let email = ""
        let password = "password123"
        let confirmPassword = "password123"

        // When
        let result = ValidationManager.validateSignUp(email: email, password: password, confirmPassword: confirmPassword)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure due to empty email, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .emptyEmail)
        }
    }
    
    func testValidateSignUpWithEmailContainingSpacesReturnsEmptyEmailError() {
        // Given
        let email = "ivan @example.com"
        let password = "password123"
        let confirmPassword = "password123"

        // When
        let result = ValidationManager.validateSignUp(email: email, password: password, confirmPassword: confirmPassword)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure due to spaces in email, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .emptyEmail)
        }
    }
    
    func testValidatePasswordWithValidPasswordsReturnsSuccess() {
        // Given
        let password = "secure123"
        let confirmPassword = "secure123"
        
        // When
        let result = ValidationManager.validatePassword(password, confirmPassword)
        
        // Then
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testValidatePasswordWithEmptyFieldsReturnsEmptyFieldsError() {
        // Given
        let password: String? = ""
        let confirmPassword: String? = ""
        
        // When
        let result = ValidationManager.validatePassword(password, confirmPassword)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .emptyFields)
        }
    }
    
    func testValidatePasswordWithNonMatchingPasswordsReturnsPasswordsDoNotMatchError() {
        // Given
        let password = "123456"
        let confirmPassword = "654321"
        
        // When
        let result = ValidationManager.validatePassword(password, confirmPassword)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .passwordsDoNotMatch)
        }
    }
    
    func testValidatePasswordWithShortPasswordReturnsPasswordTooShortError() {
        // Given
        let password = "123"
        let confirmPassword = "123"
        
        // When
        let result = ValidationManager.validatePassword(password, confirmPassword)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .passwordTooShort)
        }
    }
    
    func testValidatePasswordWithPasswordContainingSpacesReturnsPasswordContainsSpacesError() {
        // Given
        let password = "pass word"
        let confirmPassword = "pass word"
        
        // When
        let result = ValidationManager.validatePassword(password, confirmPassword)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .passwordContainsSpaces)
        }
    }
}
