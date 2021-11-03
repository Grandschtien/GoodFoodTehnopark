//
//  AuthCoordinator.swift
//  GoodFood
//
//  Created by Егор Шкарин on 01.11.2021.
//

import Foundation
import UIKit

protocol AuthCoordinatorProtocol {
    func start()
    func guestStart()
    func forgetPassword()
    func registration()
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
    
    func start() {
        let enterVC = EnterViewController()
        enterVC.coordinator = self
        navigationController?.setViewControllers([enterVC], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func forgetPassword() {
        let restorePaswordViewController = RestorePasswordViewController()
        restorePaswordViewController.coordinator = self
        let navVC = UINavigationController(rootViewController: restorePaswordViewController)
        restorePaswordViewController.title = "Восстановление пароля"
        navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    func registration() {
        let registerViewController = RegisterViewController()
        registerViewController.coordinator = self
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func enterButton() {
        tabBarController = GoodFoodCoordinator(window: window)
        tabBarController?.start()
    }
    
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        self.navigationController?.dismiss(animated: animated, completion: completion)
    }
    
}

