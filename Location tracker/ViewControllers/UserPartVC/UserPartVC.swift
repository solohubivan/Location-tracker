//
//  UserPartVC.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit
import CoreLocation
import GoogleMaps

class UserPartVC: UIViewController {

    @IBOutlet private weak var statusBarAndSwitchView: UIView!
    @IBOutlet private weak var sharingLocationStatusView: UIView!
    @IBOutlet private weak var sharingLocationStatusLabel: UILabel!
    @IBOutlet private weak var switcherStatusLabel: UILabel!
    @IBOutlet private weak var sharingLocationSwitch: UISwitch!
    @IBOutlet private weak var locationSettingsButton: UIButton!
    
    private var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    private let firebaseManager = FirebaseManager()
    
    private var lastUpdateTime: Date?
    private var lastLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - actions
    @IBAction private func sharingSelfLocationSwitcher(_ sender: Any) {
        if sharingLocationSwitch.isOn {
            locationManager.startUpdatingLocation()
            updateSharingLocationStatusUI(isSharing: true)
        } else {
            locationManager.stopUpdatingLocation()
            updateSharingLocationStatusUI(isSharing: false)
        }
    }
    
    @IBAction private func locationSettingsButtonTapped(_ sender: Any) {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Private Helper Methods
    private func saveCurrentLocationToFirebase(_ location: CLLocation) {
        let viewModel = LocationInfoViewModel(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            date: Date()
        )
        
        firebaseManager.saveUserLocation(viewModel) { result in
            switch result {
            case .success: break
            case .failure(let error):
                AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.savingLocationError, message: "\(error.localizedDescription)")
            }
        }
    }
    
    private func updateSharingLocationStatusUI(isSharing: Bool) {
        switcherStatusLabel.text = isSharing ? AppConstants.UserPartVC.stopSwitcherStatusLabelText : AppConstants.UserPartVC.startSwitcherStatusLabelText
        sharingLocationStatusLabel.text = isSharing ? AppConstants.UserPartVC.onSharingLocationStatusLabelText : AppConstants.UserPartVC.offSharingLocationStatusLabelText
        sharingLocationStatusView.backgroundColor = isSharing ? .green : .red
        statusBarAndSwitchView.backgroundColor = isSharing ? .statusBarActiveBackgroundColor : .white
        sharingLocationStatusLabel.textColor = isSharing ? .white : .statusBarFontAccentColor
        switcherStatusLabel.textColor = isSharing ? .white : .statusBarFontAccentColor
    }
    
    private func handleLocationUpdate(_ location: CLLocation) {
        let now = Date()

        guard let lastUpdate = lastUpdateTime else {
            performLocationUpdate(with: location, at: now)
            return
        }

        guard let lastLoc = lastLocation else {
            performLocationUpdate(with: location, at: now)
            return
        }

        let timePassed = now.timeIntervalSince(lastUpdate) >= 5
        let distancePassed = location.distance(from: lastLoc) >= 10

        if timePassed || distancePassed {
            performLocationUpdate(with: location, at: now)
        }
    }
    
    private func performLocationUpdate(with location: CLLocation, at time: Date) {
        lastUpdateTime = time
        lastLocation = location
        updateMapCamera(to: location.coordinate)
        saveCurrentLocationToFirebase(location)
    }
    
    private func updateMapCamera(to coordinate: CLLocationCoordinate2D) {
        let cameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: 14)
        mapView.animate(with: cameraUpdate)
    }
    
    private func updateLocationAuthorizationUI(isAuthorized: Bool) {
        locationSettingsButton.isHidden = isAuthorized
        sharingLocationSwitch.isEnabled = isAuthorized
        switcherStatusLabel.isEnabled = isAuthorized
        sharingLocationStatusView.isHidden = !isAuthorized
        sharingLocationStatusLabel.text = isAuthorized ? AppConstants.UserPartVC.offSharingLocationStatusLabelText : AppConstants.UserPartVC.disabledSharingLocationStatusLabelText
    }
}

// MARK: - CLLocationManagerDelegate
extension UserPartVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        handleLocationUpdate(newLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.locationError, message: "\(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let isAuthorized = status == .authorizedAlways

        guard isAuthorized else {
            AlertFactory.showLocationPermissionAlert(on: self)
            updateLocationAuthorizationUI(isAuthorized: false)
            return
        }
        updateLocationAuthorizationUI(isAuthorized: true)
    }
}

// MARK: - Setup UI
extension UserPartVC {
    
    private func setupUI() {
        setupLocationManager()
        setupGoogleMap()
        setupStatusBarAndSwitchView()
        setupSharingLocationStatusView()
        setupSharingLocationStatusLabel()
        setupSwitcherStatusLabel()
    }
    
    private func setupGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 50.4501, longitude: 30.5234, zoom: 8)
        let options = GMSMapViewOptions()
        options.camera = camera
        
        mapView = GMSMapView(options: options)
        mapView.frame = self.view.bounds
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(mapView, at: 0)
    }
    
    private func setupStatusBarAndSwitchView() {
        statusBarAndSwitchView.layer.cornerRadius = 15
        statusBarAndSwitchView.layer.borderWidth = 1
        statusBarAndSwitchView.layer.masksToBounds = true
        statusBarAndSwitchView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupSharingLocationStatusView() {
        sharingLocationStatusView.layer.cornerRadius = sharingLocationStatusView.frame.width / 2
        sharingLocationStatusView.clipsToBounds = true
        sharingLocationStatusView.backgroundColor = .red
    }
    
    private func setupSharingLocationStatusLabel() {
        sharingLocationStatusLabel.text = AppConstants.UserPartVC.sharingLocationStatusLabelText
        sharingLocationStatusLabel.font = UIFont(name: AppConstants.Fonts.robotoMedium, size: 17)
        sharingLocationStatusLabel.textColor = .statusBarFontAccentColor
    }
    
    private func setupSwitcherStatusLabel() {
        switcherStatusLabel.text = AppConstants.UserPartVC.switcherStatusLabelText
        switcherStatusLabel.font = UIFont(name: AppConstants.Fonts.robotoMedium, size: 20)
        switcherStatusLabel.textColor = .statusBarFontAccentColor
    }
}
