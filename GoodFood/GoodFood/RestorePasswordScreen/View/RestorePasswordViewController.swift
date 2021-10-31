//
//  RestorePasswordViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 29.10.2021.
//

import UIKit

class RestorePasswordViewController: UIViewController, RegistrationProtocol {
    
    
    private var mainLabel: UILabel = UILabel()
    private var mailLabel: UILabel = UILabel()
    private var mailTF: UITextField = UITextField()
    private var helpLabel: UILabel = UILabel()
    private var mailStackView: UIStackView = UIStackView()
    
    private var sendButton: UIButton = UIButton()
    
    
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
        setupLabel()
        setupMailStackVeiw()
        setupButton()
    }
    
    ///Setup navigation bar
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"), style: .plain, target: self, action: #selector(backAction))
    }
    
    private func setupLabel() {
        self.mainLabel.translatesAutoresizingMaskIntoConstraints = false
        setupMainLabel(self.mainLabel, text: "Введите адрес электронной почты")
        self.mainLabel.numberOfLines = 0
        self.mainLabel.textAlignment = .center
        self.view.addSubview(mainLabel)
        self.mainLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45).isActive = true
        self.mainLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -45).isActive = true
        self.mainLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
    }
    
    private func setupMailStackVeiw() {
        self.mailStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mailStackView.addArrangedSubview(mailLabel)
        self.mailStackView.addArrangedSubview(mailTF)
        self.mailStackView.addArrangedSubview(helpLabel)
        self.view.addSubview(mailStackView)
        setupStackViews(self.mailStackView, spacing: 0, aligment: .leading)
        setupMailLabel()
        setupMailTF()
        setupHelpLabel()
        self.mailStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        self.mailStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        self.mailStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.mailStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -120).isActive = true
    }
    
    private func setupMailLabel() {
        self.mailLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(self.mailLabel, text: "Почта")
        self.mailLabel.leadingAnchor.constraint(equalTo: self.mailStackView.leadingAnchor, constant: 0).isActive = true
        self.mailLabel.trailingAnchor.constraint(equalTo: self.mailStackView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    private func setupMailTF() {
        self.mailTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(self.mailTF, superView: self.view)
        self.mailTF.leadingAnchor.constraint(equalTo: self.mailStackView.leadingAnchor,
                                             constant: 0).isActive = true
        self.mailTF.trailingAnchor.constraint(equalTo: self.mailStackView.trailingAnchor,
                                              constant: 0).isActive = true
        
    }
    
    private func setupButton(){
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false  
        setupMainButtons(self.sendButton, text: "Отправить")
        self.view.addSubview(sendButton)
        self.sendButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                 constant: 56).isActive = true
        self.sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                  constant: -56).isActive = true
        self.sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -26).isActive = true
        self.sendButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupHelpLabel() {
        self.helpLabel.translatesAutoresizingMaskIntoConstraints = false
        setupTextLabels(helpLabel, text: "Вам придет письмо с дальнейшими указаниями")
        self.helpLabel.leadingAnchor.constraint(equalTo: self.mailStackView.leadingAnchor,
                                                 constant: 0).isActive = true
        self.helpLabel.trailingAnchor.constraint(equalTo: self.mailStackView.trailingAnchor,
                                                  constant: 0).isActive = true
    
    }
    
}


extension RestorePasswordViewController {
    @objc
    private func backAction() {
        dismiss(animated: true, completion: nil)
    }
}
