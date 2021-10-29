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
        self.mailStackView.translatesAutoresizingMaskIntoConstraints = false
        self.passwordStackView.translatesAutoresizingMaskIntoConstraints = false
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
        
        setupStackViews(textFieldsStackView, spacing: 8)
        
        // Настройка mailStackView
        setupStackViews(mailStackView, spacing: 8)
        self.mailStackView.leadingAnchor.constraint(equalTo: self.textFieldsStackView.leadingAnchor,
                                                    constant: 0).isActive = true
        self.mailStackView.trailingAnchor.constraint(equalTo: self.textFieldsStackView.trailingAnchor,
                                                     constant: 0).isActive = true
        //Настройка passwordStackView
        
        setupStackViews(passwordStackView, spacing: 5)
        self.passwordStackView.leadingAnchor.constraint(equalTo: self.textFieldsStackView.leadingAnchor,
                                                        constant: 0).isActive = true
        self.passwordStackView.trailingAnchor.constraint(equalTo: self.textFieldsStackView.trailingAnchor,
                                                         constant: 0).isActive = true
        //Настройка остальных view
        setupMailTF()
        setupPasswordTF()
        setupFogetButton()
        
    }
    //MARK: - Настройки текстовых полей
    private func setupMailTF() {
        self.mailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mailTF.translatesAutoresizingMaskIntoConstraints = false
        
        setupTextLabels(mailLabel, text: "Почта")
        setupTF(mailTF, superView: self.view)
        
        self.mailStackView.addArrangedSubview(mailLabel)
        self.mailStackView.addArrangedSubview(mailTF)
        //constraints
        self.mailTF.trailingAnchor.constraint(equalTo: self.mailStackView.trailingAnchor,
                                              constant: 0).isActive = true
        self.mailTF.leadingAnchor.constraint(equalTo: self.mailStackView.leadingAnchor,
                                             constant: 0).isActive = true
        self.mailLabel.trailingAnchor.constraint(equalTo: self.mailStackView.trailingAnchor,
                                                 constant: 0).isActive = true
        self.mailLabel.leadingAnchor.constraint(equalTo: self.mailStackView.leadingAnchor,
                                                constant: 0).isActive = true
    }
    
    private func setupPasswordTF() {
        self.passwordTF.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(passwordLabel, text: "Пароль")
        setupTF(passwordTF, superView: self.view)
        self.passwordTF.isSecureTextEntry = true
        self.passwordStackView.addArrangedSubview(passwordLabel)
        self.passwordStackView.addArrangedSubview(passwordTF)
        //constraints
        self.passwordTF.trailingAnchor.constraint(equalTo: self.passwordStackView.trailingAnchor).isActive = true
        self.passwordTF.leadingAnchor.constraint(equalTo: self.passwordStackView.leadingAnchor).isActive = true
        
        self.passwordLabel.trailingAnchor.constraint(equalTo: self.passwordStackView.trailingAnchor,
                                                     constant: 0).isActive = true
        self.passwordLabel.leadingAnchor.constraint(equalTo: self.passwordStackView.leadingAnchor,
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
        self.noAccountButton.translatesAutoresizingMaskIntoConstraints = false
        self.guestButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        //Настройка stackView
        self.buttonStackView.axis = .vertical
        self.buttonStackView.spacing = 4
        self.buttonStackView.distribution = .fill
        self.buttonStackView.contentMode = .scaleToFill
        self.buttonStackView.alignment = .center
        
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
        setupButton(noAccountButton, text: "Нет аккаунта? Нажмите сюда", alignment: .center)
        self.noAccountButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        
    }
    //MARK: - настройка кнопки "войти как гость"
    ///настройка кнопки "войти как гость"
    private func setupGuestButton() {
        setupButton(guestButton, text: "Или войдите как гость", alignment: .center)
    }
    
}
//MARK: - Actions
extension EnterViewController {
    
    @objc
    private func enterEnterButtonAction(_ sender: UIButton) {
        //TODO: Переход в меню
    }
    
    @objc
    private func guestButtonAction(_ sender: UIButton){
        //TODO: Переход в меню
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
