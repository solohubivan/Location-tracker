//
//  LoginVCUITests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 05.06.2025.
//

import XCTest

final class LoginVCUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestsAutoLogin")
        app.launch()
        openLoginVC()
    }
    
    func testLoginVCObjectsExist() {
        let loginVCBackgroundImg = app.images["LoginVCBackgroundImgId"]
        let mainTitleLabel = app.staticTexts["MainTitleLabelId"]
        let loginVCEmailTF = app.textFields["LoginVCEmailTFId"]
        let logInButton = app.buttons["LogInButtonId"]
        let loginVCSingUpLabel = app.staticTexts["LoginVCSingUpLabelId"]
        let loginVCSingUpButton = app.buttons["LoginVCSingUpButtonId"]
        
        XCTAssertTrue(loginVCBackgroundImg.waitForExistence(timeout: 5))
        XCTAssertTrue(mainTitleLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(loginVCEmailTF.waitForExistence(timeout: 5))
        XCTAssertTrue(logInButton.waitForExistence(timeout: 5))
        XCTAssertTrue(loginVCSingUpLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(loginVCSingUpButton.waitForExistence(timeout: 5))
    }
}

// MARK: - Helpers
private extension LoginVCUITests {
    
    private func openLoginVC() {
        let userProfileTabbarButton = app.tabBars.buttons.element(boundBy: 2)
        let logOutButton = app.buttons["LogOutButtonId"]
        
        XCTAssertTrue(userProfileTabbarButton.waitForExistence(timeout: 5))
        userProfileTabbarButton.tap()
        
        XCTAssertTrue(logOutButton.waitForExistence(timeout: 5))
        logOutButton.tap()
    }
}
