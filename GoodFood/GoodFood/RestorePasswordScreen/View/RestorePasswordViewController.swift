//
//  RestorePasswordViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 29.10.2021.
//

import UIKit

class RestorePasswordViewController: UIViewController, RegistrationProtocol {
    
    
    private var mainLabel = UILabel()
    private var mailLabel = UILabel()
    private var mailTF = UITextField()
    private var helpLabel = UILabel()
    private var mailStackView = UIStackView()
    
    private var sendButton = MainButton(color: UIColor(named: "mainColor"), title: "Отправить")
    
    private var coordinator: CoordinatorProtocol?
    private(set) var viewModel: RestorePasswordViewModel?
    var enter:(() -> Void)?
    var back: (() -> Void)?
    
    
    init(viewModel: RestorePasswordViewModel, coordinator: CoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}
//MARK: - Setup views
extension RestorePasswordViewController {
    /// Setup all views
    private func setupViews() {
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupConstraints()
        setupUI()
    }
    ///Setup navigation bar
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"), style: .plain, target: self, action: #selector(backAction))
    }
    
    private func setupConstraints() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 45),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -45),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 45)
        ])
        mailStackView.translatesAutoresizingMaskIntoConstraints = false
        mailStackView.addArrangedSubview(mailLabel)
        mailStackView.addArrangedSubview(mailTF)
        mailStackView.addArrangedSubview(helpLabel)
        
        view.addSubview(mailStackView)
        NSLayoutConstraint.activate([
            mailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: 30),
            mailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -30),
            mailStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor,
                                                   constant: 0),
            mailStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                   constant: -120)
        ])
        
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mailLabel.leadingAnchor.constraint(equalTo: mailStackView.leadingAnchor,
                                               constant: 0),
            mailLabel.trailingAnchor.constraint(equalTo: mailStackView.trailingAnchor,
                                                constant: 0)
        ])
        
        
        mailTF.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mailTF.leadingAnchor.constraint(equalTo: mailStackView.leadingAnchor,
                                            constant: 0),
            mailTF.trailingAnchor.constraint(equalTo: mailStackView.trailingAnchor,
                                             constant: 0)
        ])
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 56),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -56),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -26),
            sendButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            helpLabel.leadingAnchor.constraint(equalTo: mailStackView.leadingAnchor,
                                               constant: 0),
            helpLabel.trailingAnchor.constraint(equalTo: mailStackView.trailingAnchor,
                                                constant: 0)
        ])
        
    }
    
    private func setupUI() {
        title = "Восстановление пароля"
        mailTF.delegate = self
        setupMainLabel(mainLabel, text: "Введите адрес электронной почты")
        mainLabel.numberOfLines = 0
        mainLabel.textAlignment = .center
        setupStackViews(mailStackView, spacing: 0, aligment: .leading)
        setupTextLabels(mailLabel, text: "Почта")
        setupTF(mailTF, superView: view)
        setupTextLabels(helpLabel, text: "Вам придет письмо с дальнейшими указаниями")
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        
    }
    
}


extension RestorePasswordViewController {
    @objc
    private func backAction() {
        back?()
    }
    @objc
    private func sendAction() {
        if let mail = mailTF.text, !mail.isEmpty {
            viewModel?.restore(email: mail, completion: { error in
                if let error = error {
                    self.makeAlert(error)
                } else {
                    self.back?()
                }
            })
        } else {
            makeAlert("Введите почту.")
        }
    }
}

extension RestorePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
