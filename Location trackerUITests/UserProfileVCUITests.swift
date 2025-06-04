//
//  UserProfileVCUITests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 05.06.2025.
//

import XCTest

final class UserProfileVCUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestsAutoLogin")
        app.launch()
    }
 
    func testUserProfileVCObjectsExists() {
        let managerTabBarButton = app.tabBars.buttons.element(boundBy: 2)
        let userProfileImageView = app.images["UserProfileImageViewId"]
        let userNameLabel = app.staticTexts["UserNameLabelId"]
        let userEmailLabel = app.staticTexts["UserEmailLabelId"]
        let editProfileImageButton = app.buttons["EditProfileImageButtonId"]
        let changePasswordButton = app.buttons["ChangePasswordButtonId"]
        let logOutButton = app.buttons["LogOutButtonId"]
        
        
        XCTAssert(managerTabBarButton.waitForExistence(timeout: 5))
        managerTabBarButton.tap()
        
        XCTAssertTrue(userProfileImageView.waitForExistence(timeout: 5))
        XCTAssertTrue(userNameLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(userEmailLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(editProfileImageButton.waitForExistence(timeout: 5))
        XCTAssertTrue(changePasswordButton.waitForExistence(timeout: 5))
        XCTAssertTrue(logOutButton.waitForExistence(timeout: 5))
        
        sleep(2)
    }
}
