//
//  ManagerPageVCUITests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 05.06.2025.
//

import XCTest

final class ManagerPageVCUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestsAutoLogin")
        app.launch()
    }
    
    func testManagerPageVCObjectExists() {
        let managerTabBarButton = app.tabBars.buttons.element(boundBy: 1)
        let managerPageToolbarView = app.otherElements["ManagerPageToolbarViewId"]
        let refreshDataButton = app.buttons["RefreshDataButtonId"]
        let datePicker = app.datePickers["DatePickerId"]

        XCTAssert(managerTabBarButton.waitForExistence(timeout: 5))
        managerTabBarButton.tap()
        
        XCTAssertTrue(managerPageToolbarView.exists)
        XCTAssertTrue(datePicker.exists)
        XCTAssertTrue(refreshDataButton.exists)
        
        sleep(2)
    }
    
    func testPerformanceExample() {
        let managerTabBarButton = app.tabBars.buttons.element(boundBy: 1)
        let refreshDataButton = app.buttons["RefreshDataButtonId"]
        let datePicker = app.datePickers["DatePickerId"]
        let day = app.staticTexts["4"]
        
        XCTAssert(managerTabBarButton.waitForExistence(timeout: 5))
        managerTabBarButton.tap()
        
        XCTAssert(datePicker.waitForExistence(timeout: 5))
        datePicker.tap()
        sleep(2)
        
        XCTAssertTrue(day.exists)
        day.tap()
        sleep(3)
        
        XCTAssertTrue(refreshDataButton.exists)
        refreshDataButton.tap()
        sleep(2)
    }
}
