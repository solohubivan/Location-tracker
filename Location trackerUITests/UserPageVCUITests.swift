//
//  UserPageVCUITests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 04.06.2025.
//

import XCTest

final class UserPageVCUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestsAutoLogin")
        app.launch()
    }
    
    func testUserPageVCObjectsExist() {
        let statusBarAndSwitchView = app.otherElements["StatusBarAndSwitchViewId"]
        let sharingLocationStatusLabel = app.staticTexts["SharingLocationStatusLabelId"]
        let switcherStatusLabel = app.staticTexts["SwitcherStatusLabelId"]
        let sharingLocationSwitch = app.switches["SharingLocationSwitchId"]
        
        XCTAssertTrue(statusBarAndSwitchView.waitForExistence(timeout: 5))
        XCTAssertTrue(sharingLocationStatusLabel.exists)
        XCTAssertTrue(switcherStatusLabel.exists)
        XCTAssertTrue(sharingLocationSwitch.exists)
        
        sleep(2)
    }
    
    func testChangeSharingLocationStatus() {
        let sharingLocationSwitch = app.switches["SharingLocationSwitchId"]
        
        XCTAssertTrue(sharingLocationSwitch.waitForExistence(timeout: 5))
        sleep(1)
        sharingLocationSwitch.tap()
        sleep(2)
        sharingLocationSwitch.tap()
        sleep(2)
    }
}
