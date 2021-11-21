//
//  ProfileViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 31.10.2021.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private let profileImageView = UIImageView(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: 200,
                                                             height: 200))
    private let mainNameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let phoneTF = UITextField()
    private let phoneStackView = UIStackView()
    private let mailLabel = UILabel()
    private let mailTF = UITextField()
    private let mailStackView = UIStackView()
    private let tFStackView = UIStackView()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: ProfileViewModel?
    
    var exit: (() -> Void)?
    var imagePicker: (() -> Void)?
    
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
        setupViewsWithNetwork()
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
        profileImageView.contentMode = .scaleToFill
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.addGestureRecognizer(tapGR)
        profileImageView.isUserInteractionEnabled = true
        
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
        phoneTF.text = "*Будет позже*"
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
    func setupViewsWithNetwork() {
        viewModel?.fetchProfile(completion: {[weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.mainNameLabel.text = profile.name
                    self?.mailTF.text = profile.email
                    self?.profileImageView.image = UIImage(data: profile.image) ?? UIImage(named: "profile")
                }
            case .failure(_):
                break
            }
        })
    }
}

extension ProfileViewController {
    @objc
    private func exitAction() {
        exit?()
    }
    @objc
    private func imageTapped() {
        imagePicker?()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
