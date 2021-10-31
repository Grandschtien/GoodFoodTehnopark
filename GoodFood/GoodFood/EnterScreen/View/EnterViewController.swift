//
//  ViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 19.10.2021.
//

import UIKit



class EnterViewController: UIViewController, RegistrationProtocol {
    
    private var enterLabel: UILabel = UILabel()
    
    private var mailTF: UITextField = UITextField()
    private var mailLabel: UILabel = UILabel()
    private var passwordTF:  UITextField = UITextField()
    private var passwordLabel: UILabel = UILabel()
    private var forgetPasswordButton: UIButton = UIButton()
    private var passwordStackView: UIStackView = UIStackView()
    private var mailStackView: UIStackView = UIStackView()
    private var textFieldsStackView: UIStackView = UIStackView()
    
    private var enterButton: UIButton = UIButton()
    private var noAccountButton: UIButton = UIButton()
    private var guestButton: UIButton = UIButton()
    private var buttonStackView: UIStackView = UIStackView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - SetupViews
extension EnterViewController {
    ///Настройка всех view
    private func setupViews() {
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setupEnterLabel()
        setupTextFieldStackView()
        setupButtonStackView()
    }
    //MARK: - Настройка верхнего лейбла
    /// Настройка для label "Вход"
    private func setupEnterLabel() {
        setupMainLabel(self.enterLabel, text: "Вход")
        self.view.addSubview(enterLabel)
        self.enterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.enterLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.enterLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    //MARK: - Настройка первого stackView
    /// Настройка stackVeiws
    private func setupTextFieldStackView() {
        self.textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldsStackView.addArrangedSubview(mailStackView)
        self.textFieldsStackView.addArrangedSubview(passwordStackView)
        self.textFieldsStackView.addArrangedSubview(forgetPasswordButton)
        self.view.addSubview(textFieldsStackView)
        
        //Настройка самого stackView
        self.textFieldsStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -70).isActive = true
        self.textFieldsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                          constant: 30).isActive = true
        self.textFieldsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                           constant: -30).isActive = true
        
        setupStackViews(textFieldsStackView, spacing: 8, aligment: .leading)
        
        // Настройка mailStackView
        setupEnterScreenStackViews(stackView: mailStackView, spacing: 8, aligment: .leading)
        //Настройка passwordStackView
        setupEnterScreenStackViews(stackView: passwordStackView, spacing: 5, aligment: .leading)

        //Настройка остальных view
        setupTextFields(self.mailTF, stackView: mailStackView, label: mailLabel, labelText: "Почта")
        setupTextFields(self.passwordTF, stackView: passwordStackView, label: passwordLabel, labelText: "Пароль")
        self.passwordTF.isSecureTextEntry = true
        setupFogetButton()
        
    }
    private func setupEnterScreenStackViews(stackView: UIStackView, spacing: CGFloat, aligment: UIStackView.Alignment) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(stackView, spacing: spacing, aligment: aligment)
        stackView.leadingAnchor.constraint(equalTo: self.textFieldsStackView.leadingAnchor,
                                                        constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.textFieldsStackView.trailingAnchor,
                                                         constant: 0).isActive = true
    }
    
    //MARK: - Настройки текстовых полей
    /// Функция для настройки связки стека, лейбла и тестового поля
    private func setupTextFields(_ tf: UITextField, stackView: UIStackView, label: UILabel, labelText: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        setupTextLabels(label, text: labelText)
        setupTF(tf, superView: self.view)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(tf)
        //constraints
        tf.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                              constant: 0).isActive = true
        tf.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,
                                             constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                                 constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,
                                                constant: 0).isActive = true
    }
    
    //MARK: - Настройка кнопки забыл пароль
    private func setupFogetButton() {
        setupButton(forgetPasswordButton, text: "Забыли пароль? Нажмите сюда", alignment: .leading)
        self.forgetPasswordButton.addTarget(self, action: #selector(forgetPasswodButtonAction(_:)), for: .touchUpInside)
        
        self.forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.forgetPasswordButton.trailingAnchor.constraint(equalTo: self.textFieldsStackView.trailingAnchor,
                                                            constant: 0).isActive = true
        self.forgetPasswordButton.leadingAnchor.constraint(equalTo: self.textFieldsStackView.leadingAnchor,
                                                           constant: 0).isActive = true
       
    }
    //MARK: - Настройка нижнего stackView
    private func setupButtonStackView() {
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        self.buttonStackView.addArrangedSubview(enterButton)
        self.buttonStackView.addArrangedSubview(noAccountButton)
        self.buttonStackView.addArrangedSubview(guestButton)
        self.view.addSubview(buttonStackView)
        self.buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                      constant: 56).isActive = true
        self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                       constant: -56).isActive = true
        self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                     constant: -40).isActive = true

        setupStackViews(buttonStackView, spacing: 4, aligment: .center)
        
        // Настройка кнопок
        setupEnterButton()
        setupNoAccountButton()
        setupGuestButton()
    }
    //MARK: - Настройка кнопоки "Войти"
    private func setupEnterButton() {
        self.enterButton.translatesAutoresizingMaskIntoConstraints = false
        self.enterButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.enterButton.leadingAnchor.constraint(equalTo: self.buttonStackView.leadingAnchor,
                                                  constant: 0).isActive = true
        self.enterButton.trailingAnchor.constraint(equalTo: self.buttonStackView.trailingAnchor,
                                                   constant: 0).isActive = true
        setupMainButtons(enterButton, text: "Войти")
        self.enterButton.addTarget(self, action: #selector(enterEnterButtonAction(_:)), for: .touchUpInside)
    }
    
    //MARK: - Настройка кнопки "нет аккаунта"
    private func setupNoAccountButton() {
        self.noAccountButton.translatesAutoresizingMaskIntoConstraints = false
        setupButton(noAccountButton, text: "Нет аккаунта? Нажмите сюда", alignment: .center)
        self.noAccountButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        
    }
    //MARK: - настройка кнопки "войти как гость"
    ///настройка кнопки "войти как гость"
    private func setupGuestButton() {
        self.guestButton.translatesAutoresizingMaskIntoConstraints = false
        setupButton(guestButton, text: "Или войдите как гость", alignment: .center)
    }
    
}
//MARK: - Actions
extension EnterViewController {
    
    @objc
    private func enterEnterButtonAction(_ sender: UIButton) {
        let tabBarController = UITabBarController()
        
        let menuViewController = MenuViewController()
        menuViewController.tabBarItem = UITabBarItem(title: "Меню", image:  UIImage(named: "menu"), selectedImage:  UIImage(named: "menu"))
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image:  UIImage(named: "Profile"), selectedImage:  UIImage(named: "Profile"))
        
        let likedVC = LikedViewController()
        likedVC.tabBarItem = UITabBarItem(title: "Избранное", image:  UIImage(named: "liked"), selectedImage:  UIImage(named: "liked"))
        
        let controllers = [menuViewController, likedVC, profileVC]
        tabBarController.viewControllers = controllers.map({ controller in
            UINavigationController(rootViewController: controller)
        })
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc
    private func guestButtonAction(_ sender: UIButton){
        let menuViewController = MenuViewController()
        
        self.navigationController?.pushViewController(menuViewController, animated: true)
    }
    
    @objc
    private func registerButtonAction(_ sender: UIButton) {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    @objc
    private func forgetPasswodButtonAction(_ sender: UIButton) {
        let restorePaswordViewController = RestorePasswordViewController()
        let navVC = UINavigationController(rootViewController: restorePaswordViewController)
        restorePaswordViewController.title = "Восстановление пароля"
        self.present(navVC, animated: true, completion: nil)
    }
}
