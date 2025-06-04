//
//  DirectionsManagerTests.swift
//  Location tracker
//
//  Created by Ivan Solohub on 04.06.2025.
//

import XCTest
@testable import Location_tracker

final class DirectionsManagerTests: XCTestCase {
    
    private var directionsManager: DirectionsManager?
    
    override func setUp() {
        super.setUp()
        directionsManager = DirectionsManager()
    }
    
    func testAreAllPointsCloseWhenAllWithinThresholdReturnsTrue() {
        // Given
        let locations = [
            LocationInfoViewModel(latitude: 50.0, longitude: 30.0, date: Date()),
            LocationInfoViewModel(latitude: 50.0001, longitude: 30.0001, date: Date()),
            LocationInfoViewModel(latitude: 50.0002, longitude: 30.0002, date: Date())
        ]
        let thresholdMeters = 100.0

        // When
        guard let manager = directionsManager else { return }
        let result = manager.areAllPointsClose(locations, thresholdInMeters: thresholdMeters)

        // Then
        XCTAssertTrue(result)
    }

    func testAreAllPointsCloseWhenSomeOutsideThresholdReturnsFalse() {
        // Given
        let locations = [
            LocationInfoViewModel(latitude: 50.0, longitude: 30.0, date: Date()),
            LocationInfoViewModel(latitude: 51.0, longitude: 31.0, date: Date())
        ]
        let threshold = 100.0

        // When
        guard let manager = directionsManager else { return }
        let result = manager.areAllPointsClose(locations, thresholdInMeters: threshold)

        // Then
        XCTAssertFalse(result)
    }
    
    func testTestFilterNearbyLocationsRemovesClosePoints() {
        // Given
        let now = Date()
        let locations = [
            LocationInfoViewModel(latitude: 50.0, longitude: 30.0, date: now),
            LocationInfoViewModel(latitude: 50.00001, longitude: 30.00001, date: now.addingTimeInterval(1)),
            LocationInfoViewModel(latitude: 50.0001, longitude: 30.0001, date: now.addingTimeInterval(2)),
            LocationInfoViewModel(latitude: 50.5, longitude: 30.5, date: now.addingTimeInterval(3)),
        ]

        // When
        let result = directionsManager?.testFilterNearbyLocations(locations, distance: 10)

        // Then
        XCTAssertEqual(result?.count, 3)
    }
    
    func testTestFilterNearbyLocationsRemovesAllMiddlePointsIfTooClose() {
        // Given
        let now = Date()
        let locations = [
            LocationInfoViewModel(latitude: 50.0, longitude: 30.0, date: now),
            LocationInfoViewModel(latitude: 50.00001, longitude: 30.00001, date: now.addingTimeInterval(1)),
            LocationInfoViewModel(latitude: 50.00002, longitude: 30.00002, date: now.addingTimeInterval(2)),
            LocationInfoViewModel(latitude: 50.00003, longitude: 30.00003, date: now.addingTimeInterval(3)),
            LocationInfoViewModel(latitude: 50.00004, longitude: 30.00004, date: now.addingTimeInterval(4)),
            LocationInfoViewModel(latitude: 50.5, longitude: 30.5, date: now.addingTimeInterval(5))
        ]

        // When
        let result = directionsManager?.testFilterNearbyLocations(locations, distance: 100)
        
        // Then
        XCTAssertEqual(result?.count, 2, "Expected only first and last point to remain")
    }
}
