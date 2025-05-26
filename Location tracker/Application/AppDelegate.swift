//
//  AppDelegate.swift
//  Location tracker
//
//  Created by Ivan Solohub on 02.05.2025.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyD9Am0UJLwMMa-UBa6X-lm5MjK0-gBF8h4")
        return true
    }
}

