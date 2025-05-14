//
//  MainTabBarController.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let userPartVC = UserPartVC()
    private let managerPartVC = ManagerPartVC()
    private let userProfileVC = UserProfileVC()
    private var userProfileNavController: UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileNavController = UINavigationController(rootViewController: userProfileVC)
        setupTabBar()
    }
    
    // MARK: - Setup UI
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor(red: 0.9490, green: 0.9490, blue: 0.9686, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: 0.3882, green: 0.3882, blue: 0.4000, alpha: 1.0)
        tabBar.tintColor = UIColor(red: 0.0, green: 0.7020, blue: 0.8980, alpha: 1.0)
        
        tabBar.overrideUserInterfaceStyle = .light
        
        let userPartNavController = UINavigationController(rootViewController: userPartVC)
        userPartNavController.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "location.north.circle"), tag: 0)
        
        let managerPartNavController = UINavigationController(rootViewController: managerPartVC)
        managerPartNavController.tabBarItem = UITabBarItem(title: "Manager", image: UIImage(systemName: "location.magnifyingglass"), tag: 1)
        
        userProfileNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        
        viewControllers = [userPartNavController, managerPartNavController, userProfileNavController]
    }
}
