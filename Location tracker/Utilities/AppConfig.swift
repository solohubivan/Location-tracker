//
//  AppConfig.swift
//  Location tracker
//
//  Created by Ivan Solohub on 27.05.2025.
//

import Foundation

enum AppConfig {
    static func googleMapsAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["GoogleMapsAPIKey"] as? String else {
            fatalError("❌ Google Maps API Key not found in Config.plist")
        }
        return key
    }
}
