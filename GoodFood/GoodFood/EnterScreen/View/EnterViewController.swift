//
//  ViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 19.10.2021.
//

import UIKit



class EnterViewController: UIViewController {
    
    //UI
    private let enterLabel = UILabel()
    
    private let mailTF = UITextField()
    private let mailLabel = UILabel()
    private let passwordTF = UITextField()
    private let passwordLabel = UILabel()
    private let forgetPasswordButton = HelperButton(color: .white,
                                                    title: "Забыли пароль? Нажмите сюда",
                                                    aligment: .leading)
    private let passwordStackView = UIStackView()
    private let mailStackView = UIStackView()
    private let textFieldsStackView = UIStackView()
    
    private let enterButton = MainButton(color: UIColor(named: "mainColor"), title: "Войти")
    private let noAccountButton = HelperButton(color: .white,
                                               title: "Нет аккаунта? Нажмите сюда",
                                               aligment: .center)
    private let guestButton = HelperButton(color: .white,
                                           title: "Или войдите как гость",
                                           aligment: .center)
    private let buttonStackView = UIStackView()
    //properties
    
    private(set) var viewModel: EnterViewModel?
    private var coordinator: CoordinatorProtocol?
    
    var enter: (() -> Void)?
    var registration: (() -> Void)?
    var forgetPassword: (() -> Void)?
    
    init(viewModel: EnterViewModel, coordinator: CoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        setupConstraints()
        setupUI()
    }
    
    private func setupConstraints() {
        enterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterLabel)
        
        NSLayoutConstraint.activate([
            enterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            enterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldsStackView.addArrangedSubview(mailStackView)
        setupTextFields(mailTF, stackView: mailStackView, label: mailLabel)
        setupEnterScreenStackViews(mailStackView)
        
        textFieldsStackView.addArrangedSubview(passwordStackView)
        setupTextFields(passwordTF, stackView: passwordStackView, label: passwordLabel)
        setupEnterScreenStackViews(passwordStackView)
        
        textFieldsStackView.addArrangedSubview(forgetPasswordButton)
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forgetPasswordButton.trailingAnchor.constraint(equalTo: textFieldsStackView.trailingAnchor,
                                                           constant: 0),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: textFieldsStackView.leadingAnchor,
                                                          constant: 0)
        ])
        
        view.addSubview(textFieldsStackView)
        
        NSLayoutConstraint.activate([
            textFieldsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            textFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: 30),
            textFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: -30)
        ])
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterButton.heightAnchor.constraint(equalToConstant: 70),
            enterButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor,
                                                 constant: 0),
            enterButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor,
                                                  constant: 0)
        ])
        
        buttonStackView.addArrangedSubview(noAccountButton)
        noAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.addArrangedSubview(guestButton)
        guestButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: 56),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -56),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                    constant: -40)
        ])
        view.addSubview(buttonStackView)
        
    }
    
    private func setupUI() {
        mailTF.delegate = self
        passwordTF.delegate = self
        
        textFieldsStackView.axis = .vertical
        textFieldsStackView.spacing = 8
        textFieldsStackView.distribution = .fill
        textFieldsStackView.contentMode = .scaleToFill
        textFieldsStackView.alignment = .leading
        // Настройка mailStackView
        mailStackView.axis = .vertical
        mailStackView.spacing = 5
        mailStackView.distribution = .fill
        mailStackView.contentMode = .scaleToFill
        mailStackView.alignment = .leading
        //Настройка passwordStackView
        passwordStackView.axis = .vertical
        passwordStackView.spacing = 5
        passwordStackView.distribution = .fill
        passwordStackView.contentMode = .scaleToFill
        passwordStackView.alignment = .leading
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 4
        buttonStackView.distribution = .fill
        buttonStackView.contentMode = .scaleToFill
        buttonStackView.alignment = .center
        
        enterLabel.text = "Вход"
        enterLabel.font = enterLabel.font.withSize(30)
        enterLabel.sizeToFit()
        
        mailLabel.text = "Почта"
        mailLabel.font = UIFont(name: "system", size: 15)
        mailLabel.font = mailLabel.font.withSize(15)
        mailLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        mailTF.font = UIFont(name: "system", size: 17)
        mailTF.font = mailTF.font?.withSize(17)
        mailTF.setUnderLine(superView: view)
        
        passwordLabel.text = "Пароль"
        passwordLabel.font = UIFont(name: "system", size: 15)
        passwordLabel.font = passwordLabel.font.withSize(15)
        passwordLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        passwordTF.font = UIFont(name: "system", size: 17)
        passwordTF.font = passwordTF.font?.withSize(17)
        passwordTF.setUnderLine(superView: view)
        passwordTF.isSecureTextEntry = true
        
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswodButtonAction(_:)), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(enterEnterButtonAction(_:)), for: .touchUpInside)
        noAccountButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(guestButtonAction(_:)), for: .touchUpInside)
    }
    
    private func setupEnterScreenStackViews(_ stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: textFieldsStackView.leadingAnchor,
                                               constant: 0),
            stackView.trailingAnchor.constraint(equalTo: textFieldsStackView.trailingAnchor,
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
extension EnterViewController {
    @objc
    private func enterEnterButtonAction(_ sender: UIButton) {
        if let mail = mailTF.text, !mail.isEmpty,
           let password = passwordTF.text, !password.isEmpty {
            
            viewModel?.checkLogIn(email: mailTF.text ?? "", password: passwordTF.text ?? "") { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.makeAlert(error)
                    } else {
                        self.enter?()
                    }
                }
            }
        } else {
            makeAlert("Заполните поля логина и пароля")
        }
    }
    
    @objc
    private func guestButtonAction(_ sender: UIButton){
        enter?()
    }
    
    @objc
    private func registerButtonAction(_ sender: UIButton) {
        registration?()
    }
    @objc
    private func forgetPasswodButtonAction(_ sender: UIButton) {
        forgetPassword?()
    }
}

extension EnterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
