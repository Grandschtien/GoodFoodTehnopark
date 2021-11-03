//
//  GoodFoodCoordinator.swift
//  GoodFood
//
//  Created by Егор Шкарин on 01.11.2021.
//

import Foundation
import UIKit

final class GoodFoodCoordinator {
    private var window: UIWindow
    private(set) var tabBarController: UITabBarController = UITabBarController()
  
    
    init(window: UIWindow) {
        self.window = window
    }

}

extension GoodFoodCoordinator {    
    func start() {
        let menuViewController = MenuViewController()
        menuViewController.coordinator = self
        menuViewController.tabBarItem = UITabBarItem(title: "Меню", image:  UIImage(named: "menu"), selectedImage:  UIImage(named: "menu"))
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image:  UIImage(named: "Profile"), selectedImage:  UIImage(named: "Profile"))
        
        let likedVC = LikedViewController()
        likedVC.tabBarItem = UITabBarItem(title: "Избранное", image:  UIImage(named: "liked"), selectedImage:  UIImage(named: "liked"))
        
        let controllers = [menuViewController, likedVC, profileVC]
        tabBarController.viewControllers = controllers.map({ controller in
            UINavigationController(rootViewController: controller)
        })
        
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
    }
}
