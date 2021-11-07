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
    
    private var coordinator: CoordinatorProtocol?
    private(set) var viewModel: RegisterViewModel?
    var enter: (()->Void)?
    var back: (()->Void)?
    
    
    init(viewModel: RegisterViewModel, coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
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
        back?()
    }
}

//MARK: - НАстройка constraints
extension RegisterViewController {
    private func setupViews() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupConstraints()
        setupUI()
    }
    
    private func setupConstraints() {
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerLabel)
        NSLayoutConstraint.activate([
            registerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                        constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                         constant: -30),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor,
                                                        constant: 0),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
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
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        userAgreementLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                          constant: 56),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                           constant: -56),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                         constant: -28)
        ])
        
        buttonStackView.addArrangedSubview(registerButton)
        buttonStackView.addArrangedSubview(userAgreementLabel)
        
        NSLayoutConstraint.activate([
            registerButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor,
                                                         constant: 0),
            registerButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor,
                                                          constant: 0),
            registerButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
    }
    
    private func setupUI() {
        registerLabel.text = "Регистрация"
        registerLabel.font = registerLabel.font.withSize(30)
        registerLabel.sizeToFit()
        passwordTF.isSecureTextEntry = true
        passwordTF.isSecureTextEntry = true
        setupStackViews(mainStackView, spacing: 8, aligment: .leading)
        setupStackViews(buttonStackView, spacing: 8, aligment:  .center)
        setupMainButtons(registerButton, text: "Зарегистрироваться")
        setupAgreementLabel()
        registerButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
    }
    
    private func setupRegisterTextStackViews(_ tf: UITextField, label: UILabel, stackView: UIStackView, labelText: String) {
        tf.translatesAutoresizingMaskIntoConstraints = false
        setupTF(tf, superView: view)
        
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
        
        mainStackView.addArrangedSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor,
                                               constant: 0),
            stackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor,
                                                constant: 0)
        ])
        
        
    }
    //MARK: - Настрйока лейбля пользовательского соглажения
    /// Настрйока лейбля пользовательского соглажения
    private func setupAgreementLabel() {
        userAgreementLabel.text = "Нажимая кнопку “Зарегистрироваться”, вы принимаете пользовательское соглашение"
        userAgreementLabel.textAlignment = .center
        userAgreementLabel.numberOfLines = 3
        userAgreementLabel.font = UIFont(name: "system", size: 13)
        userAgreementLabel.font = passwordLabel.font.withSize(13)
        userAgreementLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
    }
}

//MARK: - Actions
extension RegisterViewController {
    @objc
    private func registerButtonAction(_ sender: UIButton) {
        enter?()
    }
}
