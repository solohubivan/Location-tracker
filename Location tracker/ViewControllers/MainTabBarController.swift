//
//  MainTabBarController.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let userPartVC = UserPageVC()
    private let managerPartVC = ManagerPageVC()
    private let userProfileVC = UserProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Setup UI
    private func setupTabBar() {
        tabBar.backgroundColor = .tabbarBackgroundColor
        tabBar.unselectedItemTintColor = .tabbarUnselectedItemColor
        tabBar.tintColor = .tabbarChooseItemColor
        
        tabBar.overrideUserInterfaceStyle = .light
        
        userPartVC.tabBarItem = UITabBarItem(title: AppConstants.MainTabBarController.userPartVcTitleText, image: UIImage(systemName: AppConstants.ImagesNames.locationNorthCircle), tag: 0)
        
        managerPartVC.tabBarItem = UITabBarItem(title: AppConstants.MainTabBarController.managerPartVcTitleText, image: UIImage(systemName: AppConstants.ImagesNames.locationMagnifyingglass), tag: 1)
        
        userProfileVC.tabBarItem = UITabBarItem(title: AppConstants.MainTabBarController.profileVcTitleText, image: UIImage(systemName: AppConstants.ImagesNames.personCropCircle), tag: 2)
        
        viewControllers = [userPartVC, managerPartVC, userProfileVC]
    }
}
