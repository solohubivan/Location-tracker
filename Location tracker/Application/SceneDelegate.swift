//
//  SceneDelegate.swift
//  Location tracker
//
//  Created by Ivan Solohub on 02.05.2025.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            
        guard let windowScene = (scene as? UIWindowScene) else { return }
        FirebaseApp.configure()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        if Auth.auth().currentUser != nil {
            showMain()
        } else {
            showLogin()
        }
    }
    
    // MARK: private methods helpers
    private func showMain() {
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }

    private func showLogin() {
        window?.rootViewController = LoginVC()
        window?.makeKeyAndVisible()
    }
}

