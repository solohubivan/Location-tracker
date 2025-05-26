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
        } else {
            locationManager.stopUpdatingLocation()
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
                AlertFactory.showSimpleAlertWithOK(on: self, title: "Saving location error", message: "\(error.localizedDescription)")
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension UserPartVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        let now = Date()
        // force unwrap
        let timePassed = lastUpdateTime == nil || now.timeIntervalSince(lastUpdateTime!) >= 5

        let distancePassed: Bool
        if let lastLoc = lastLocation {
            let distance = newLocation.distance(from: lastLoc)
            distancePassed = distance >= 10
        } else {
            distancePassed = true
        }

        // Якщо виконано хоча б одну з умов — оновлюємо
        if timePassed || distancePassed {
            lastUpdateTime = now
            lastLocation = newLocation
            let cameraUpdate = GMSCameraUpdate.setTarget(newLocation.coordinate, zoom: 14)
            mapView.animate(with: cameraUpdate)
            
            saveCurrentLocationToFirebase(newLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Помилка геолокації: \(error.localizedDescription)")
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
        setupSharingLocationSwitch()
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
    }
    
    private func setupSharingLocationStatusLabel() {
        sharingLocationStatusLabel.text = "Location not sharing"
        sharingLocationStatusLabel.font = UIFont(name: "Roboto-Medium", size: 17)
    }
    
    private func setupSwitcherStatusLabel() {
        switcherStatusLabel.text = "Start sharing"
        switcherStatusLabel.font = UIFont(name: "Roboto-Medium", size: 20)
    }
    
    private func setupSharingLocationSwitch() {
        
    }
}

