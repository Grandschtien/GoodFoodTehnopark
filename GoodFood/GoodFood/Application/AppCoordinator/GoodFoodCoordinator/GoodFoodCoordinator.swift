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
        
        menuViewController.sort = {
            let sortVC = SortViewController()
            sortVC.modalPresentationStyle = .custom
            sortVC.transitioningDelegate = menuViewController.transition
            sortVC.close = {
                sortVC.dismiss(animated: true, completion: nil)
            }
            menuViewController.present(sortVC, animated: true)
        }
        
        let profileViewModel = ProfileViewModel()
        let profileVC = ProfileViewController(coordinator: self, viewModel: profileViewModel)
        profileVC.exit = { [weak self] in
            guard let `self` = self else { return }
            let navController = UINavigationController()
            let authCoordinator = AuthCoordinator(window: self.window, navigationController: navController, tabBarController: self)
            authCoordinator.start()
        }
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image:  UIImage(named: "Profile"), selectedImage:  UIImage(named: "Profile"))
        
        let likedViewModel = LikedViewModel()
        let likedVC = LikedViewController(viewModel: likedViewModel, coordinator: self)
        likedVC.tabBarItem = UITabBarItem(title: "Избранное", image:  UIImage(named: "liked"), selectedImage:  UIImage(named: "liked"))
        
        let controllers = [menuViewController, likedVC, profileVC]
        tabBarController.viewControllers = controllers.map({ controller in
            UINavigationController(rootViewController: controller)
        })
        
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
    }
}
