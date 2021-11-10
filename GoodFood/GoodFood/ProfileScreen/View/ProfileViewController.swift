//
//  ProfileViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 31.10.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileImageView: UIImageView = UIImageView(frame:
                                                                CGRect(x: 0,
                                                                       y: 0,
                                                                       width: 200,
                                                                       height: 200))
    private let mainNameLabel: UILabel = UILabel()
    private let phoneLabel: UILabel = UILabel()
    private let phoneTF: UITextField = UITextField()
    private let phoneStackView: UIStackView = UIStackView()
    private let mailLabel: UILabel = UILabel()
    private let mailTF: UITextField = UITextField()
    private let mailStackView: UIStackView = UIStackView()
    private let tFStackView: UIStackView = UIStackView()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: ProfileViewModel?
    
    var exit: (() -> Void)?
    
    init(coordinator: CoordinatorProtocol, viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
    }
    
}


extension ProfileViewController {
    private func setupConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        mainNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainNameLabel)
        NSLayoutConstraint.activate([
            mainNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                               constant: 30)
        ])
        //MARK: - tFStackView
        tFStackView.translatesAutoresizingMaskIntoConstraints = false
        tFStackView.addArrangedSubview(mailStackView)
        tFStackView.addArrangedSubview(phoneStackView)
        view.addSubview(tFStackView)
        
        NSLayoutConstraint.activate([
            tFStackView.topAnchor.constraint(equalTo: mainNameLabel.bottomAnchor,
                                             constant: 40),
            tFStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: 30),
            tFStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -30)
        ])
        
        //MARK: - nameStackView
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        
        phoneStackView.addArrangedSubview(phoneLabel)
        phoneStackView.addArrangedSubview(phoneTF)
        //constraints
        NSLayoutConstraint.activate([
            phoneTF.trailingAnchor.constraint(equalTo: phoneStackView.trailingAnchor,
                                             constant: 0),
            phoneTF.leadingAnchor.constraint(equalTo: phoneStackView.leadingAnchor,
                                            constant: 0),
            phoneLabel.trailingAnchor.constraint(equalTo: phoneStackView.trailingAnchor,
                                                constant: 0),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneStackView.leadingAnchor,
                                               constant: 0),
            phoneStackView.leadingAnchor.constraint(equalTo: tFStackView.leadingAnchor,
                                                   constant: 0),
            phoneStackView.trailingAnchor.constraint(equalTo: tFStackView.trailingAnchor,
                                                    constant: 0)
        ])
        
        //MARK: - mailStackView
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        mailTF.translatesAutoresizingMaskIntoConstraints = false
        mailStackView.addArrangedSubview(mailLabel)
        mailStackView.addArrangedSubview(mailTF)
        //constraints
        NSLayoutConstraint.activate([
            mailTF.trailingAnchor.constraint(equalTo: mailStackView.trailingAnchor,
                                             constant: 0),
            mailTF.leadingAnchor.constraint(equalTo: mailStackView.leadingAnchor,
                                            constant: 0),
            mailLabel.trailingAnchor.constraint(equalTo: mailStackView.trailingAnchor,
                                                constant: 0),
            mailLabel.leadingAnchor.constraint(equalTo: mailStackView.leadingAnchor,
                                               constant: 0),
            mailStackView.leadingAnchor.constraint(equalTo: tFStackView.leadingAnchor,
                                                   constant: 0),
            mailStackView.trailingAnchor.constraint(equalTo: tFStackView.trailingAnchor,
                                                    constant: 0)
        ])
        
        
    }
    
    private func setupUI() {
        title = "Профиль"
        self.view.backgroundColor = .white
        let exitButton = UIBarButtonItem(image: UIImage(named: "exit"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(exitAction))
        navigationItem.setRightBarButtonItems([exitButton],
                                              animated: true)
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.image = UIImage(named: "profile")
        
        mainNameLabel.text  = "Ваше имя"
        mainNameLabel.font = mainNameLabel.font.withSize(30)
        
        // Стек вью для текстовых полей
        tFStackView.axis = .vertical
        tFStackView.spacing = 8
        tFStackView.distribution = .fill
        tFStackView.contentMode = .scaleToFill
        tFStackView.alignment = .leading
        
        // Поля для поля имени
        phoneStackView.axis = .vertical
        phoneStackView.spacing = 5
        phoneStackView.distribution = .fill
        phoneStackView.contentMode = .scaleToFill
        phoneStackView.alignment = .leading
        
        phoneLabel.text = "Телефон"
        phoneLabel.font = UIFont(name: "system", size: 15)
        phoneLabel.font = phoneLabel.font.withSize(15)
        phoneLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        
        phoneTF.font = UIFont(name: "system", size: 17)
        phoneTF.font = phoneTF.font?.withSize(17)
        phoneTF.setUnderLine(superView: view)
        phoneTF.text = "8(999)111-11-11"
        phoneTF.isUserInteractionEnabled = false
        
        //Поля для поля почты
        mailStackView.axis = .vertical
        mailStackView.spacing = 5
        mailStackView.distribution = .fill
        mailStackView.contentMode = .scaleToFill
        mailStackView.alignment = .leading
        
        mailLabel.text = "Почта"
        mailLabel.font = UIFont(name: "system", size: 15)
        mailLabel.font = mailLabel.font.withSize(15)
        mailLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        
        mailTF.font = UIFont(name: "system", size: 17)
        mailTF.font = mailTF.font?.withSize(17)
        mailTF.setUnderLine(superView: view)
        mailTF.text = "example@yandex.ru"
        mailTF.isUserInteractionEnabled = false
        
        
    }
}

extension ProfileViewController {
    @objc
    private func exitAction() {
        
    }
}
