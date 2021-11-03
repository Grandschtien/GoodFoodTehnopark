//
//  RegisterViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 28.10.2021.
//

import UIKit

class RegisterViewController: UIViewController, RegistrationProtocol {
    // Label регистрация
    private let registerLabel: UILabel = UILabel()
    
    // Текстовое поле имени
    private let nameLabel: UILabel = UILabel()
    private let nameTF: UITextField = UITextField()
    private let nameStackView: UIStackView = UIStackView()
    
    // Текстовое поле почты
    private let mailLabel: UILabel = UILabel()
    private let mailTF: UITextField = UITextField()
    private let mailStackView: UIStackView = UIStackView()
    
    // Текстовое поле пароля
    private let passwordLabel: UILabel = UILabel()
    private let passwordTF: UITextField = UITextField()
    private let passwordStackView: UIStackView = UIStackView()
    
    // Текстовое поле повторения пароля
    private let checkPasswordLabel: UILabel = UILabel()
    private let checkPasswordTF: UITextField = UITextField()
    private let checkPasswordStackView: UIStackView = UIStackView()
    
    // Главный стек
    private let mainStackView: UIStackView = UIStackView()
    private let registerButton: UIButton = UIButton()
    private let userAgreementLabel: UILabel = UILabel()
    private let buttonStackView: UIStackView = UIStackView()
    
    var coordinator: AuthCoordinator?
    
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
        self.coordinator?.pop(animated: true)
    }
}

//MARK: - НАстройка constraints
extension RegisterViewController {
    private func setupViews() {
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupConstraints()
        setupUI()
    }
    
    private func setupConstraints() {
        self.registerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(registerLabel)
        NSLayoutConstraint.activate([
            self.registerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.registerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        ])
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mainStackView)
        NSLayoutConstraint.activate([
            self.mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                        constant: 30),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                         constant: -30),
            self.mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,
                                                        constant: 0),
            self.mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,
                                                        constant: -130)
        ])
        setupRegisterTextStackViews(nameTF,
                                    label: nameLabel,
                                    stackView: nameStackView,
                                    labelText: "Имя")
        setupRegisterTextStackViews(mailTF,
                                    label: mailLabel,
                                    stackView: mailStackView,
                                    labelText: "Почта")
        setupRegisterTextStackViews(passwordTF, label:
                                    passwordLabel, stackView:
                                    passwordStackView,
                                    labelText: "Пароль")
        setupRegisterTextStackViews(checkPasswordTF,
                                    label: checkPasswordLabel,
                                    stackView: checkPasswordStackView,
                                    labelText: "Повторите пароль")
        
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.userAgreementLabel.translatesAutoresizingMaskIntoConstraints = false
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            self.buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                          constant: 56),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                           constant: -56),
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                         constant: -28)
        ])
        
        self.buttonStackView.addArrangedSubview(registerButton)
        self.buttonStackView.addArrangedSubview(userAgreementLabel)
        
        NSLayoutConstraint.activate([
            self.registerButton.leadingAnchor.constraint(equalTo: self.buttonStackView.leadingAnchor,
                                                         constant: 0),
            self.registerButton.trailingAnchor.constraint(equalTo: self.buttonStackView.trailingAnchor,
                                                          constant: 0),
            self.registerButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
    }
    
    private func setupUI() {
        self.registerLabel.text = "Регистрация"
        self.registerLabel.font = self.registerLabel.font.withSize(30)
        self.registerLabel.sizeToFit()
        self.passwordTF.isSecureTextEntry = true
        self.passwordTF.isSecureTextEntry = true
        setupStackViews(mainStackView, spacing: 8, aligment: .leading)
        setupStackViews(buttonStackView, spacing: 8, aligment:  .center)
        
        setupMainButtons(registerButton, text: "Зарегистрироваться")
        setupAgreementLabel()
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
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,
                                           constant: 0),
            tf.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                         constant: 0)
        ])
        
        self.mainStackView.addArrangedSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor,
                                               constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor,
                                                constant: 0)
        ])
        
        
    }
    //MARK: - Настрйока лейбля пользовательского соглажения
    /// Настрйока лейбля пользовательского соглажения
    private func setupAgreementLabel() {
        self.userAgreementLabel.text = "Нажимая кнопку “Зарегистрироваться”, вы принимаете пользовательское соглашение"
        self.userAgreementLabel.textAlignment = .center
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
        coordinator?.enterButton()
    }
}
