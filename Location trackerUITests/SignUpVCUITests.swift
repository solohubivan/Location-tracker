//
//  SignUpVCUITests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 05.06.2025.
//

import XCTest

final class SignUpVCUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestsAutoLogin")
        app.launch()
        openLoginVC()
    }
    
    func testLoginVCObjectsExist() {
        let backgroundBlurView = app.otherElements["SignUpVCBlurViewId"]
        let loginVCSingUpButton = app.buttons["LoginVCSingUpButtonId"]
        let signUpUserNameTF = app.textFields["SignUpUserNameTFId"]
        let signUpUserEmailTF = app.textFields["SignUpUserEmailTFId"]
        let singUpButton = app.buttons["SingUpVCSingUpButtonId"]
        
        XCTAssertTrue(loginVCSingUpButton.waitForExistence(timeout: 5))
        loginVCSingUpButton.tap()
        
        XCTAssertTrue(backgroundBlurView.waitForExistence(timeout: 5))
        XCTAssertTrue(signUpUserNameTF.waitForExistence(timeout: 5))
        XCTAssertTrue(signUpUserEmailTF.waitForExistence(timeout: 5))
        XCTAssertTrue(singUpButton.waitForExistence(timeout: 5))
        
        sleep(2)
    }
}

// MARK: - Helpers
private extension SignUpVCUITests {
    
    private func openLoginVC() {
        let userProfileTabbarButton = app.tabBars.buttons.element(boundBy: 2)
        let logOutButton = app.buttons["LogOutButtonId"]
        
        XCTAssertTrue(userProfileTabbarButton.waitForExistence(timeout: 5))
        userProfileTabbarButton.tap()
        
        XCTAssertTrue(logOutButton.waitForExistence(timeout: 5))
        logOutButton.tap()
    }
}
