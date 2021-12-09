//
//  GoodFoodCoordinator.swift
//  GoodFood
//
//  Created by Егор Шкарин on 01.11.2021.
//

import Foundation
import UIKit
import FirebaseAuth

final class GoodFoodCoordinator {
    private var window: UIWindow
    private(set) var tabBarController: UITabBarController = UITabBarController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
}

extension GoodFoodCoordinator: CoordinatorProtocol {    
    func start() {
        AppNetworkManager.setupUserDefaults() 
        let menuViewController = MenuViewController(coordinatror: self)
        
        menuViewController.tabBarItem = UITabBarItem(title: "Меню",
                                                     image:  UIImage(named: "menu"),
                                                     selectedImage:  UIImage(named: "menu"))
        menuViewController.add = {
            let addVC = AddViewController()
            addVC.back = {
                addVC.dismiss(animated: true)
            }
            let addNavController = UINavigationController(rootViewController: addVC)
            menuViewController.present(addNavController, animated: true, completion: nil)
        }
        menuViewController.sort = {
            let sortVC = SortViewController()
            sortVC.modalPresentationStyle = .custom
            sortVC.transitioningDelegate = menuViewController.transition
            sortVC.close = {
                sortVC.dismiss(animated: true, completion: nil)
            }
            menuViewController.present(sortVC, animated: true)
        }
        
        menuViewController.dish = { dishKey in
            let dishVC = DishViewController(key: dishKey, coordinatror: self)
            dishVC.back = {
                dishVC.navigationController?.popViewController(animated: true)
            }
            dishVC.nextAction = { [weak self] dishKey in
                guard let `self` = self else { return }
                let prepareViewController = PrepareViewController(key: dishKey, coordinatror: self)
                prepareViewController.back = {
                    dishVC.navigationController?.popViewController(animated: true)
                }
                prepareViewController.exit = {
                    
                }
                dishVC.navigationController?.pushViewController(prepareViewController, animated: true)
            }
            menuViewController.navigationController?.pushViewController(dishVC, animated: true)
        }
        
        let profileViewModel = ProfileViewModel()
        let profileVC = ProfileViewController(coordinator: self, viewModel: profileViewModel)
        profileVC.exit = { [weak self] in
            guard let `self` = self else { return }
            do {
                try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
            let navController = UINavigationController()
            let authCoordinator = AuthCoordinator(window: self.window,
                                                  navigationController: navController,
                                                  tabBarController: self)
            authCoordinator.start()
        }
        
        profileVC.imagePicker = {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = profileVC
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                profileVC.present(imagePicker, animated: true, completion: nil)
            }
            else {
                let alert  = UIAlertController(title: "Предупреждение",
                                               message: "Разрешите использование приложением камеры.",
                                               preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                profileVC.present(alert, animated: true, completion: nil)
            }
        }
        profileVC.tabBarItem = UITabBarItem(title: "Профиль",
                                            image:  UIImage(named: "Profile"),
                                            selectedImage:  UIImage(named: "Profile"))
        
        let yourRecipesViewModel = YourRecipesViewModel()
        let histroyViewModel = HistoryViewModel()
        let yourRecipeVC = YourRecipesViewController(viewModel: yourRecipesViewModel, coordinator: self)
        let historyVC = HistoryViewController(viewModel: histroyViewModel, coordinator: self)
        let likedVC = LikedViewController(coordinator: self)
        likedVC.dish = { dishKey in
            let dishVC = DishViewController(key: dishKey, coordinatror: self)
            dishVC.back = {
                dishVC.navigationController?.popViewController(animated: true)
            }
            dishVC.nextAction = { [weak self] dishKey in
                guard let `self` = self else { return }
                let prepareViewController = PrepareViewController(key: dishKey, coordinatror: self)
                prepareViewController.back = {
                    dishVC.navigationController?.popViewController(animated: true)
                }
                prepareViewController.exit = {
                    
                }
                dishVC.navigationController?.pushViewController(prepareViewController, animated: true)
            }
            likedVC.navigationController?.pushViewController(dishVC, animated: true)
        }
        
        let containerVC = ContainerViewController(subViewControllers: [likedVC, yourRecipeVC, historyVC])
        containerVC.tabBarItem = UITabBarItem(title: "Избранное",
                                              image:  UIImage(named: "liked"),
                                              selectedImage:  UIImage(named: "liked"))
        
        let controllers = [menuViewController, containerVC, profileVC]
        tabBarController.viewControllers = controllers.map({ controller in
            UINavigationController(rootViewController: controller)
        })
        
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
    }
}
