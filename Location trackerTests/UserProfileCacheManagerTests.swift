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
        _ = try? XCTUnwrap(cacheManager).clear()
    }
    
    func testSaveAndLoadUserProfile() throws {
        // Given
        let profile = UserProfileViewModel(userName: "Ivan", email: "ivan@example.com", imageURL: "http://image.com/1.png")
        let manager = try XCTUnwrap(cacheManager)

        // When
        manager.save(profile: profile)
        let loaded = manager.load()

        // Then
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.userName, profile.userName)
        XCTAssertEqual(loaded?.email, profile.email)
        XCTAssertEqual(loaded?.imageURL, profile.imageURL)
    }
    
    func testLoadWhenNoProfileSavedReturnsNil() throws {
        // When
        let manager = try XCTUnwrap(cacheManager)
        let loaded = manager.load()
        
        // Then
        XCTAssertNil(loaded)
    }
    
    func testClearRemovesSavedProfile() throws {
        // Given
        let manager = try XCTUnwrap(cacheManager)
        let profile = UserProfileViewModel(userName: "Ivan", email: "ivan@example.com", imageURL: "http://image.com/1.png")
        manager.save(profile: profile)
        
        // When
        manager.clear()
        let loaded = manager.load()
        
        // Then
        XCTAssertNil(loaded)
    }
}
