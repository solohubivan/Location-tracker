//
//  UserProfileCacheManagerTests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 04.06.2025.
//

import XCTest
@testable import Location_tracker

final class UserProfileCacheManagerTests: XCTestCase {
    
    private var cacheManager: UserProfileCacheManager?
    
    override func setUp() {
        super.setUp()
        cacheManager = UserProfileCacheManager()
        cacheManager?.clear()
    }
    
    func testSaveAndLoadUserProfile() {
        // Given
        let profile = UserProfileViewModel(userName: "Ivan", email: "ivan@example.com", imageURL: "http://image.com/1.png")

        // When
        cacheManager?.save(profile: profile)
        let loaded = cacheManager?.load()

        // Then
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.userName, profile.userName)
        XCTAssertEqual(loaded?.email, profile.email)
        XCTAssertEqual(loaded?.imageURL, profile.imageURL)
    }
    
    func testLoadWhenNoProfileSavedReturnsNil() {
        // When
        let loaded = cacheManager?.load()
        
        // Then
        XCTAssertNil(loaded)
    }
    
    func testClearRemovesSavedProfile() {
        // Given
        let profile = UserProfileViewModel(userName: "Ivan", email: "ivan@example.com", imageURL: "http://image.com/1.png")
        cacheManager?.save(profile: profile)
        
        // When
        cacheManager?.clear()
        let loaded = cacheManager?.load()
        
        // Then
        XCTAssertNil(loaded)
    }
}
