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
    
    private(set) var viewModel: EnterViewModel?
    private var coordinator: CoordinatorProtocol?
    
    var enter: (()->Void)?
    var registration: (()->Void)?
    var forgetPassword: (()->Void)?
 
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
        setupStackViews(textFieldsStackView, spacing: 8, aligment: .leading)
        // Настройка mailStackView
        setupStackViews(mailStackView, spacing: 8, aligment: .leading)
        //Настройка passwordStackView
        setupStackViews(passwordStackView, spacing: 5, aligment: .leading)
        setupStackViews(buttonStackView, spacing: 4, aligment: .center)
        setupMainLabel(enterLabel, text: "Вход")
        setupTextLabels(mailLabel, text: "Почта")
        setupTF(mailTF, superView: view)
        setupTextLabels(passwordLabel, text: "Пароль")
        setupTF(passwordTF, superView: view)
        passwordTF.isSecureTextEntry = true
        setupButton(forgetPasswordButton, text: "Забыли пароль? Нажмите сюда", alignment: .leading)
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswodButtonAction(_:)), for: .touchUpInside)
        setupMainButtons(enterButton, text: "Войти")
        enterButton.addTarget(self, action: #selector(enterEnterButtonAction(_:)), for: .touchUpInside)
        setupButton(noAccountButton, text: "Нет аккаунта? Нажмите сюда", alignment: .center)
        noAccountButton.addTarget(self, action: #selector(registerButtonAction(_:)), for: .touchUpInside)
        setupButton(guestButton, text: "Или войдите как гость", alignment: .center)
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
        enter?()
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
