//
//  RegisterViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 28.10.2021.
//

import UIKit

class RegisterViewController: UIViewController, RegistrationProtocol {
    // Label регистрация
    private var registerLabel: UILabel = UILabel()
    
    // Текстовое поле имени
    private var nameLabel: UILabel = UILabel()
    private var nameTF: UITextField = UITextField()
    private var nameStackView: UIStackView = UIStackView()
    
    // Текстовое поле почты
    private var mailLabel: UILabel = UILabel()
    private var mailTF: UITextField = UITextField()
    private var mailStackView: UIStackView = UIStackView()
    
    // Текстовое поле пароля
    private var passwordLabel: UILabel = UILabel()
    private var passwordTF: UITextField = UITextField()
    private var passwordStackView: UIStackView = UIStackView()
    
    // Текстовое поле повторения пароля
    private var checkPasswordLabel: UILabel = UILabel()
    private var checkPasswordTF: UITextField = UITextField()
    private var checkPasswordStackView: UIStackView = UIStackView()
    
    // Главный стек
    private var mainStackView: UIStackView = UIStackView()
    private var registerButton: UIButton = UIButton()
    private var userAgreementLabel: UILabel = UILabel()
    private var buttonStackView: UIStackView = UIStackView()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Настройка NavigationBar
extension RegisterViewController {
    /// Настройка панели навигации
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"), style: .plain, target: self, action: #selector(backAction))
    }
    /// Акшон кнопки назад
    @objc
    private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - НАстройка constraints
extension RegisterViewController {
    private func setupViews() {
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupRegisterLabel()
        setupMainStackView()
        setupButtonStackView()
    }
    //MARK: - Настрйока лейбла Регистрация
    /// Настройка лейбла регистрации
    private func setupRegisterLabel() {
        self.registerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.registerLabel.text = "Регистрация"
        self.registerLabel.font = self.registerLabel.font.withSize(30)
        self.registerLabel.sizeToFit()
        self.view.addSubview(registerLabel)
        self.registerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        self.registerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
    }
    //MARK: - Настройка стека для поля имени
    /// Настройка стека для поля имени
    private func setupNameStackView() {
        self.nameTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(nameTF, superView: self.view)
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(nameLabel, text: "Имя")
        
        self.nameStackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(nameStackView, spacing: 0)
        
        self.nameStackView.addArrangedSubview(nameLabel)
        self.nameStackView.addArrangedSubview(nameTF)
        
        self.nameLabel.leadingAnchor.constraint(equalTo: self.nameStackView.leadingAnchor,
                                                constant: 0).isActive = true
        self.nameTF.trailingAnchor.constraint(equalTo: self.nameStackView.trailingAnchor,
                                              constant: 0).isActive = true
        self.mainStackView.addArrangedSubview(nameStackView)
        self.nameStackView.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor,
                                                    constant: 0).isActive = true
        self.nameStackView.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor,
                                                     constant: 0).isActive = true
    }
    
    //MARK: - Настройка стека для поля почты
    /// Настройка стека для поля почты
    private func setupMailStackView() {
        self.mailTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(mailTF, superView: self.view)
        self.mailLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(mailLabel, text: "Почта")
        
        self.mailStackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(mailStackView, spacing: 0)
        
        self.mailStackView.addArrangedSubview(mailLabel)
        self.mailStackView.addArrangedSubview(mailTF)
        
        self.mailLabel.leadingAnchor.constraint(equalTo: self.mailStackView.leadingAnchor,
                                                constant: 0).isActive = true
        self.mailTF.trailingAnchor.constraint(equalTo: self.mailStackView.trailingAnchor,
                                              constant: 0).isActive = true
        self.mainStackView.addArrangedSubview(mailStackView)
        
        //  стек почты внутри основного стека (констреинты)
        self.mailStackView.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor,
                                                    constant: 0).isActive = true
        self.mailStackView.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor,
                                                     constant: 0).isActive = true
    }
    //MARK: - Настройка стека для поля пароля
    /// Настройка стека для поля пароля
    private func setupPasswordStackView() {
        
        self.passwordTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(passwordTF, superView: self.view)
        passwordTF.isSecureTextEntry = true
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(passwordLabel, text: "Пароль")
        
        self.passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(passwordStackView, spacing: 0)
        self.passwordStackView.addArrangedSubview(passwordLabel)
        self.passwordStackView.addArrangedSubview(passwordTF)
        self.passwordLabel.leadingAnchor.constraint(equalTo: self.passwordStackView.leadingAnchor,
                                                    constant: 0).isActive = true
        self.passwordTF.trailingAnchor.constraint(equalTo: self.passwordStackView.trailingAnchor,
                                                  constant: 0).isActive = true
        
        self.mainStackView.addArrangedSubview(passwordStackView)
        
        self.passwordStackView.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor,
                                                        constant: 0).isActive = true
        self.passwordStackView.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor,
                                                         constant: 0).isActive = true
    }
    //MARK: - настройка поля для поля повторения пароля
    /// настройка поля для поля повторения пароля
    private func setupCheckPasswordStackView() {
        self.checkPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(checkPasswordTF, superView: self.view)
        checkPasswordTF.isSecureTextEntry = true
        self.checkPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(checkPasswordLabel, text: "Повторите пароль")
        self.checkPasswordStackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(checkPasswordStackView, spacing: 0)
        
        self.checkPasswordStackView.addArrangedSubview(checkPasswordLabel)
        self.checkPasswordStackView.addArrangedSubview(checkPasswordTF)
        self.checkPasswordLabel.leadingAnchor.constraint(equalTo: self.checkPasswordStackView.leadingAnchor,
                                                         constant: 0).isActive = true
        self.checkPasswordTF.trailingAnchor.constraint(equalTo: self.checkPasswordStackView.trailingAnchor,
                                                       constant: 0).isActive = true
        self.mainStackView.addArrangedSubview(checkPasswordStackView)
        self.checkPasswordStackView.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor,
                                                        constant: 0).isActive = true
        self.checkPasswordStackView.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor,
                                                         constant: 0).isActive = true
    }
    //MARK: - Настрйока основного стека с текстовыми полями
    /// Настрйока стека для всех полей
    private func setupMainStackView() {
        setupNameStackView()
        setupMailStackView()
        setupPasswordStackView()
        setupCheckPasswordStackView()
        
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(mainStackView, spacing: 8)
        
        self.view.addSubview(self.mainStackView)
        self.mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: 30).isActive = true
        self.mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                     constant: -30).isActive = true
        self.mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -130).isActive = true
    }
    //MARK: - Настройка стека для кнопки регистарации
    /// Настройка стека для кнопки
    private func setupButtonStackView() {
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        setupButton()
        self.userAgreementLabel.translatesAutoresizingMaskIntoConstraints = false
        setupAgreementLabel()
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(buttonStackView, spacing: 8)
        self.view.addSubview(buttonStackView)
        self.buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: 56).isActive = true
        self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                     constant: -56).isActive = true
        self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -28).isActive = true
    }
    // MARK: - Настрйока кнопки Регистрация
    /// Настройка кнопки регистарция
    private func setupButton() {
        self.buttonStackView.addArrangedSubview(registerButton)
        
        self.registerButton.leadingAnchor.constraint(equalTo: self.buttonStackView.leadingAnchor,
                                                     constant: 0).isActive  = true
        self.registerButton.trailingAnchor.constraint(equalTo: self.buttonStackView.trailingAnchor,
                                                     constant: 0).isActive  = true
        self.registerButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        setupMainButtons(registerButton, text: "Зарегистрироваться")
        self.buttonStackView.addArrangedSubview(registerButton)
    }
    //MARK: - Настрйока лейбля пользовательского соглажения
    /// Настрйока лейбля пользовательского соглажения
    private func setupAgreementLabel() {
        self.buttonStackView.addArrangedSubview(userAgreementLabel)
        self.userAgreementLabel.text = "Нажимая кнопку “Зарегистрироваться”, вы принимаете пользовательское соглашение"
        self.userAgreementLabel.numberOfLines = 3
        self.userAgreementLabel.font = UIFont(name: "system", size: 13)
        self.userAgreementLabel.font = self.passwordLabel.font.withSize(13)
        self.userAgreementLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
    }
}

//MARK: - Actions
extension RegisterViewController {
    @objc
    private func registerButtonAction(_ sender: UIButton) {
        debugPrint("Registered")
    }
}
