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
    
    private func setupRegisterTextStackViews(_ tf: UITextField, label: UILabel, stackView: UIStackView, labelText: String) {
        tf.translatesAutoresizingMaskIntoConstraints = false
        setupTF(tf, superView: self.view)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(label, text: labelText)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(stackView, spacing: 0, aligment: .leading)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(tf)
        
        label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,
                                                constant: 0).isActive = true
        tf.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                              constant: 0).isActive = true
        self.mainStackView.addArrangedSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor,
                                                    constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor,
                                                     constant: 0).isActive = true
    }
    
    
    
    //MARK: - Настрйока основного стека с текстовыми полями
    /// Настрйока стека для всех полей
    private func setupMainStackView() {
        
        setupRegisterTextStackViews(nameTF, label: nameLabel, stackView: nameStackView, labelText: "Имя")
        setupRegisterTextStackViews(mailTF, label: mailLabel, stackView: mailStackView, labelText: "Почта")
        setupRegisterTextStackViews(passwordTF, label: passwordLabel, stackView: passwordStackView, labelText: "Пароль")
        setupRegisterTextStackViews(checkPasswordTF, label: checkPasswordLabel, stackView: checkPasswordStackView, labelText: "Повторите пароль")
        
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        setupStackViews(mainStackView, spacing: 8, aligment: .leading)
        
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
        setupStackViews(buttonStackView, spacing: 8, aligment:  .leading)
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
