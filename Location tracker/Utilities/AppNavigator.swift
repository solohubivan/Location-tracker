//
//  AppNavigator.swift
//  Location tracker
//
//  Created by Ivan Solohub on 02.06.2025.
//

import UIKit

final class AppNavigator {

    static func showMainTabBar(from viewController: UIViewController) {
        let tabBarVC = MainTabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        viewController.present(tabBarVC, animated: false)
    }

    static func showSignUpVC(from viewController: UIViewController) {
        let signUpVC = SignUpVC()
        signUpVC.modalPresentationStyle = .formSheet
        viewController.present(signUpVC, animated: true)
    }
    
    static func showLoginVC(from viewController: UIViewController) {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        viewController.present(loginVC, animated: true)
    }
}
