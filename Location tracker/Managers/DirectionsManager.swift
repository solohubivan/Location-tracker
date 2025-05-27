//
//  DirectionsManager.swift
//  Location tracker
//
//  Created by Ivan Solohub on 27.05.2025.
//

import GoogleMaps
import Foundation

final class DirectionsManager {
    
    // MARK: - External Interface
    func setupTrajectory(on mapView: GMSMapView, locations: [LocationInfoViewModel], trajectoryDistance: Double, directionDistance: Double){
        let preparedTrajectoryLocations = filterNearbyLocations(locations, customizedDistance: trajectoryDistance)
        let directionsLocations = filterNearbyLocations(locations, customizedDistance: directionDistance)
            
        drawPolyline(locations: preparedTrajectoryLocations, on: mapView)
        addStartAndEndMarkers(locations: preparedTrajectoryLocations, on: mapView)
        addDirectionArrows(locations: directionsLocations, on: mapView)
            
        if let first = preparedTrajectoryLocations.first {
            updateMapCamera(to: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude), mapView: mapView, setZoom: 14)
        }
    }
    
    func updateMapCamera(to coordinate: CLLocationCoordinate2D, mapView: GMSMapView, setZoom: Float) {
        let cameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: setZoom)
        mapView.animate(with: cameraUpdate)
    }
    
    func areAllPointsClose(_ locations: [LocationInfoViewModel], thresholdInMeters: Double) -> Bool {
        guard let first = locations.first else { return true }
        let origin = CLLocation(latitude: first.latitude, longitude: first.longitude)

        for location in locations.dropFirst() {
            let current = CLLocation(latitude: location.latitude, longitude: location.longitude)
            if origin.distance(from: current) > thresholdInMeters {
                return false
            }
        }
        return true
    }
    
    func addLocationMarker(latitude: Double, longitude: Double, title: String? = nil, color: UIColor = .red, on mapView: GMSMapView) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.icon = GMSMarker.markerImage(with: color)
        marker.map = mapView
    }
    
    // MARK: - Private methods
    private func filterNearbyLocations(_ locations: [LocationInfoViewModel], customizedDistance: Double) -> [LocationInfoViewModel] {
        let sortedLocations = locations.sorted { $0.date < $1.date }
        guard sortedLocations.count >= 2 else { return sortedLocations }

        let firstLocation = sortedLocations.first!
        let lastLocation = sortedLocations.last!
        let middleLocations = sortedLocations.dropFirst().dropLast()
        
        var filteredMiddleLocations: [LocationInfoViewModel] = []
        var lastAccepted = firstLocation
        
        for location in middleLocations {
            let current = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let last = CLLocation(latitude: lastAccepted.latitude, longitude: lastAccepted.longitude)
            if current.distance(from: last) >= customizedDistance {
                filteredMiddleLocations.append(location)
                lastAccepted = location
            }
        }

        return [firstLocation] + filteredMiddleLocations + [lastLocation]
    }

    private func drawPolyline(locations: [LocationInfoViewModel], on mapView: GMSMapView) {
        let path = GMSMutablePath()
        locations.forEach {
            path.add(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        }

        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5
        polyline.strokeColor = .systemBlue
        polyline.map = mapView
    }

    private func addStartAndEndMarkers(locations: [LocationInfoViewModel], on mapView: GMSMapView) {
        guard let first = locations.first, let last = locations.last else { return }

        addLocationMarker(latitude: first.latitude, longitude: first.longitude, title: "Start", color: .green, on: mapView)
        addLocationMarker(latitude: last.latitude, longitude: last.longitude, title: "End", color: .red, on: mapView)
    }

    private func addDirectionArrows(locations: [LocationInfoViewModel], on mapView: GMSMapView) {
        guard locations.count > 1 else { return }

        for i in 0..<locations.count - 1 {
            let from = CLLocationCoordinate2D(latitude: locations[i].latitude, longitude: locations[i].longitude)
            let to = CLLocationCoordinate2D(latitude: locations[i + 1].latitude, longitude: locations[i + 1].longitude)
            let bearing = getBearing(from: from, to: to)

            let arrow = GMSMarker()
            arrow.position = from
            arrow.icon = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            arrow.rotation = bearing
            arrow.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            arrow.map = mapView
        }
    }

    private func getBearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDirection {
        let fromLat = from.latitude.degreesToRadians
        let fromLng = from.longitude.degreesToRadians
        let toLat = to.latitude.degreesToRadians
        let toLng = to.longitude.degreesToRadians
        let dLon = toLng - fromLng

        let y = sin(dLon) * cos(toLat)
        let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLon)
        return atan2(y, x).radiansToDegrees
    }
}

// MARK: - Double Extensions for Angle Conversion
private extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}
