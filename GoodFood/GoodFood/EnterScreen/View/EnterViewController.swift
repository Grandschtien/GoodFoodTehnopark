//
//  ViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 19.10.2021.
//

import UIKit



class EnterViewController: UIViewController, RegistrationProtocol {
    
    //UI
    private let enterLabel: UILabel = UILabel()
    
    private let mailTF: UITextField = UITextField()
    private let mailLabel: UILabel = UILabel()
    private let passwordTF:  UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    private let forgetPasswordButton: UIButton = UIButton()
    private let passwordStackView: UIStackView = UIStackView()
    private let mailStackView: UIStackView = UIStackView()
    private let textFieldsStackView: UIStackView = UIStackView()
    
    private let enterButton: UIButton = UIButton()
    private let noAccountButton: UIButton = UIButton()
    private let guestButton: UIButton = UIButton()
    private let buttonStackView: UIStackView = UIStackView()
    //properties
    
    var viewModel: EnterViewModel?
    var coordinator: AuthCoordinator?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EnterViewModel()
        setupViews()
    }
}

// MARK: - SetupViews
extension EnterViewController {
    ///Настройка всех view
    private func setupViews() {
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setupConstraints()
        setupUI()
    }
    
    private func setupConstraints() {
        self.enterLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(enterLabel)
        
        NSLayoutConstraint.activate([
            self.enterLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.enterLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.textFieldsStackView.addArrangedSubview(mailStackView)
        setupTextFields(mailTF, stackView: mailStackView, label: mailLabel)
        setupEnterScreenStackViews(mailStackView)
        
        self.textFieldsStackView.addArrangedSubview(passwordStackView)
        setupTextFields(passwordTF, stackView: passwordStackView, label: passwordLabel)
        setupEnterScreenStackViews(passwordStackView)
        
        self.textFieldsStackView.addArrangedSubview(forgetPasswordButton)
        self.forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.forgetPasswordButton.trailingAnchor.constraint(equalTo: self.textFieldsStackView.trailingAnchor,
                                                                constant: 0),
            self.forgetPasswordButton.leadingAnchor.constraint(equalTo: self.textFieldsStackView.leadingAnchor,
                                                               constant: 0)
        ])
        
        self.view.addSubview(textFieldsStackView)
        
        NSLayoutConstraint.activate([
            self.textFieldsStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -70),
            self.textFieldsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                              constant: 30),
            self.textFieldsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                               constant: -30)
        ])
        
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        self.buttonStackView.addArrangedSubview(enterButton)
        self.enterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.enterButton.heightAnchor.constraint(equalToConstant: 70),
            self.enterButton.leadingAnchor.constraint(equalTo: self.buttonStackView.leadingAnchor,
                                                      constant: 0),
            self.enterButton.trailingAnchor.constraint(equalTo: self.buttonStackView.trailingAnchor,
                                                       constant: 0)
        ])
        
        self.buttonStackView.addArrangedSubview(noAccountButton)
        self.noAccountButton.translatesAutoresizingMaskIntoConstraints = false

        self.buttonStackView.addArrangedSubview(guestButton)
        self.guestButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            self.buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                          constant: 56),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                           constant: -56),
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                         constant: -40)
        ])
        self.view.addSubview(buttonStackView)
        
    }
    
    private func setupUI() {
        setupStackViews(textFieldsStackView, spacing: 8, aligment: .leading)
        // Настройка mailStackView
        setupStackViews(mailStackView, spacing: 8, aligment: .leading)
        //Настройка passwordStackView
        setupStackViews(passwordStackView, spacing: 5, aligment: .leading)
        setupStackViews(buttonStackView, spacing: 4, aligment: .center)
        setupMainLabel(enterLabel, text: "Вход")
        setupTextLabels(mailLabel, text: "Почта")
        setupTF(mailTF, superView: self.view)
        setupTextLabels(passwordLabel, text: "Пароль")
        setupTF(passwordTF, superView: self.view)
        self.passwordTF.isSecureTextEntry = true
        setupButton(forgetPasswordButton, text: "Забыли пароль? Нажмите сюда", alignment: .leading)
        self.forgetPasswordButton.addTarget(self, action: #selector(forgetPasswodButtonAction(_:)), for: .touchUpInside)
        setupMainButtons(enterButton, text: "Войти")
        self.enterButton.addTarget(self, action: #selector(enterEnterButtonAction(_:)), for: .touchUpInside)
        setupButton(noAccountButton, text: "Нет аккаунта? Нажмите сюда", alignment: .center)
        self.noAccountButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        setupButton(guestButton, text: "Или войдите как гость", alignment: .center)
        self.guestButton.addTarget(self, action: #selector(guestButtonAction(_:)), for: .touchUpInside)
    }

    private func setupEnterScreenStackViews(_ stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.textFieldsStackView.leadingAnchor,
                                                            constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.textFieldsStackView.trailingAnchor,
                                                             constant: 0)
        ])
    }
    
    //MARK: - Настройки текстовых полей
    /// Функция для настройки связки стека, лейбла и тестового поля
    private func setupTextFields(_ tf: UITextField, stackView: UIStackView, label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(tf)
        //constraints
        NSLayoutConstraint.activate([
            tf.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                                  constant: 0),
            tf.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,
                                                 constant: 0),
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                                     constant: 0),
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,
                                                    constant: 0)
        ])
    }
}
//MARK: - Actions
//TODO: Вынести всю эту залупу во viewModel
extension EnterViewController {
    
    @objc
    private func enterEnterButtonAction(_ sender: UIButton) {
        coordinator?.enterButton()
    }
    
    @objc
    private func guestButtonAction(_ sender: UIButton){
        coordinator?.enterButton()
    }
    
    @objc
    private func registerButtonAction(_ sender: UIButton) {
        coordinator?.registration()
    }
    @objc
    private func forgetPasswodButtonAction(_ sender: UIButton) {
        coordinator?.forgetPassword()
    }
}
