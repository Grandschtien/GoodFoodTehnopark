//
//  AuthCoordinator.swift
//  GoodFood
//
//  Created by Егор Шкарин on 01.11.2021.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    func start()
}

final class AuthCoordinator {
    private var window: UIWindow
    private(set) var navigationController: UINavigationController?
    private(set) var tabBarController: GoodFoodCoordinator?
    
    init(window: UIWindow, navigationController: UINavigationController?, tabBarController: GoodFoodCoordinator) {
        self.window = window
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func pop(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
    
}

extension AuthCoordinator: CoordinatorProtocol {
    func start() {
        let enterViewModel = EnterViewModel()
        let enterVC = EnterViewController(viewModel: enterViewModel, coordinator: self)
        
        enterVC.enter = { [weak self] in
            self?.tabBarController = GoodFoodCoordinator(window: self?.window ?? UIWindow())
            self?.tabBarController?.start()
        }
        
        enterVC.forgetPassword = { [weak self] in
            let restorePasswordViewModel = RestorePasswordViewModel()
            let restorePaswordViewController = RestorePasswordViewController(viewModel: restorePasswordViewModel, coordinator: self!)
            restorePaswordViewController.back = {[weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            restorePaswordViewController.enter = enterVC.enter
            
            let navVC = UINavigationController(rootViewController: restorePaswordViewController)
            self?.navigationController?.present(navVC, animated: true, completion: nil)
        }
        
        enterVC.registration = { [weak self] in
            let regisrterViewModel = RegisterViewModel()
            let registerViewController = RegisterViewController(viewModel: regisrterViewModel, coordinator: self!)
            registerViewController.enter = {[weak self] in
                self?.tabBarController = GoodFoodCoordinator(window: self?.window ?? UIWindow())
                self?.tabBarController?.start()
            }
            registerViewController.back = { [weak self] in
                self?.pop(animated: true)
            }
            self?.navigationController?.pushViewController(registerViewController, animated: true)
        }
        
        navigationController?.setViewControllers([enterVC], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
