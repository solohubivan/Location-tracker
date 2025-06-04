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
        
        if CommandLine.arguments.contains("-UITestsAutoLogin") {
            autoLoginForUITests()
        } else if Auth.auth().currentUser != nil {
            showMain()
        } else {
            showLogin()
        }
    }
    
    // MARK: private methods helpers
    private func autoLoginForUITests() {
        let email = "qwer@gmail.com"
        let password = "12345678"

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                self?.showLogin()
            } else {
                self?.showMain()
            }
        }
    }
    
    private func showMain() {
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }

    private func showLogin() {
        window?.rootViewController = LoginVC()
        window?.makeKeyAndVisible()
    }
}

