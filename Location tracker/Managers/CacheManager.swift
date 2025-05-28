//
//  CacheManager.swift
//  Location tracker
//
//  Created by Ivan Solohub on 27.05.2025.
//
import UIKit

final class CacheManager {
    
    private let key = "CachedUserProfileKey"

    func save(profile: UserProfileViewModel) {
        let cache = UserProfileViewModel(userName: profile.userName, email: profile.email, imageURL: profile.imageURL)
        if let data = try? JSONEncoder().encode(cache) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> UserProfileViewModel? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let cached = try? JSONDecoder().decode(UserProfileViewModel.self, from: data) else {
            return nil
        }
        return cached
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
