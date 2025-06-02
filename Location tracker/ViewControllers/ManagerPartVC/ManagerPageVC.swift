//
//  ManagerPageVC.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit
import GoogleMaps

class ManagerPageVC: UIViewController {
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var refreshDataButton: UIButton!
    @IBOutlet private weak var largeActivityIndicator: UIActivityIndicatorView!
    private var mapView: GMSMapView!
    
    private let firebaseManager = FirebaseManager()
    private let directionsManager = DirectionsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showCurrentDayLocationInfo()
    }
    
    // MARK: - Private helper methods
    private func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.largeActivityIndicator.isHidden = !isLoading
            isLoading ? self.largeActivityIndicator.startAnimating() : self.largeActivityIndicator.stopAnimating()
        }
    }
    
    private func dismissDatePicker() {
        guard let presented = self.presentedViewController else { return }
        presented.dismiss(animated: true)
    }
    
    private func showCurrentDayLocationInfo() {
        setLoading(true)
        firebaseManager.fetchUserLocations(for: Date()) { [weak self] locations in
            self?.setLoading(false)
            self?.displayLocations(locations)
        }
    }
    
    private func displayLocations(_ locations: [LocationInfoViewModel]) {
        mapView.clear()
        
        switch locations.count {
        case 0:
            AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.noLocationData, message: "")
        case 1:
            if let location = locations.first {
                directionsManager.addLocationMarker(latitude: location.latitude, longitude: location.longitude, on: mapView)
            }
        default:
            if directionsManager.areAllPointsClose(locations, thresholdInMeters: 30) {
                locations.forEach {
                    directionsManager.addLocationMarker(latitude: $0.latitude, longitude: $0.longitude, on: mapView)
                }
                
                guard let first = locations.first else { return }
                let coordinate = CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude)
                directionsManager.updateMapCamera(to: coordinate, mapView: mapView, setZoom: 14)
                
            } else {
                directionsManager.setupTrajectory(
                    on: mapView,
                    locations: locations,
                    trajectoryDistance: 70,
                    directionDistance: 500
                )
            }
        }
    }
    
    // MARK: - Actions
    @IBAction private func datePickerValueChanged(_ sender: Any) {
        dismissDatePicker()
        setLoading(true)
        
        let selectedDate = datePicker.date
        firebaseManager.fetchUserLocations(for: selectedDate) { [weak self] locations in
            self?.setLoading(false)
            self?.displayLocations(locations)
        }
    }
    
    @IBAction private func refreshDataButtonTapped(_ sender: Any) {
        refreshDataButton.animateRotation()
        datePicker.date = .now
        showCurrentDayLocationInfo()
    }
}

// MARK: - Setup UI
extension ManagerPageVC {
    
    private func setupUI() {
        setupGoogleMap()
        datePicker.maximumDate = .now
        largeActivityIndicator.isHidden = true
    }
    
    private func setupGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 50.4501, longitude: 30.5234, zoom: 8)
        let options = GMSMapViewOptions()
        options.camera = camera
        
        mapView = GMSMapView(options: options)
        mapView.frame = self.view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(mapView, at: 0)
    }
}
