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

extension GoodFoodCoordinator: CoordinatorProtocol {    
    func start() {
        let menuViewModel = MenuViewModel()
        let menuViewController = MenuViewController(viewModel: menuViewModel, coordinatror: self)
        
        menuViewController.tabBarItem = UITabBarItem(title: "Меню", image:  UIImage(named: "menu"), selectedImage:  UIImage(named: "menu"))
        menuViewController.add = {
            let addVC = AddViewController()
            addVC.back = {
                addVC.dismiss(animated: true, completion: nil)
            }
            let addNavController = UINavigationController(rootViewController: addVC)
            menuViewController.present(addNavController, animated: true, completion: nil)
        }
        
        let profileViewModel = ProfileViewModel()
        let profileVC = ProfileViewController(coordinator: self, viewModel: profileViewModel)
        profileVC.exit = { [weak self] in
           
        }
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
