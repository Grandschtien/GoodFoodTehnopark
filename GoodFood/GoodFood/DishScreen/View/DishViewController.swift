//
//  DishViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit
import Kingfisher
import Network

class DishViewController: UIViewController {
    
    private let tableView = ParalaxTableView()
    private var headerView: UIView?
    private var footerView: UIView?
    private let imageForHeaderView = UIImageView()
    private let nextButton = MainButton(color: UIColor(named: "mainColor"), title: "Перейти к готовке")
    private var activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    private let errorButton = UIButton(type: .roundedRect)
    private let errorStackView = UIStackView()
    
    private var likedButton: UIBarButtonItem?
    var imageHeightConstraint: NSLayoutConstraint?
    var imageBottomConstraint: NSLayoutConstraint?
    var imageLeadingConstraint: NSLayoutConstraint?
    var imageTrailingConstraint: NSLayoutConstraint?
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: DishViewModel?
    private let key: String
    var back: (() -> Void)?
    var nextAction: ((String) -> Void)?
    
    init(key: String, coordinatror: CoordinatorProtocol) {
        self.coordinator = coordinatror
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.key = ""
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        setupWaitingIndicator()
        setupConstraints()
        fetchDish()
        setupUI()
    }
}

extension DishViewController {
    
    private func setupConstraints() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        imageForHeaderView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        footerView?.addSubview(nextButton)
        headerView?.addSubview(imageForHeaderView)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        nextButton.topAnchor.constraint(equalTo: footerView!.topAnchor, constant: 20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: footerView!.trailingAnchor, constant: -25).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: footerView!.leadingAnchor, constant: 25).isActive = true
        
        imageBottomConstraint = NSLayoutConstraint(item: headerView ?? UIView(),
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem:  imageForHeaderView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
        
        imageHeightConstraint = NSLayoutConstraint(item: imageForHeaderView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 200)
        
        imageLeadingConstraint = NSLayoutConstraint(item: headerView ?? UIView(),
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: imageForHeaderView,
                                                    attribute: .leading,
                                                    multiplier: 1,
                                                    constant: 0)
        
        imageTrailingConstraint = NSLayoutConstraint(item: headerView ?? UIView(),
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: imageForHeaderView,
                                                     attribute: .trailing,
                                                     multiplier: 1,
                                                     constant: 0)
        
        imageHeightConstraint?.isActive = true
        imageBottomConstraint?.isActive = true
        imageLeadingConstraint?.isActive = true
        imageTrailingConstraint?.isActive = true
        
        imageBottomConstraint?.identifier = "imageBottomConstraint"
        imageHeightConstraint?.identifier = "imageHeightConstraint"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = UIColor(named: "BackgroundColor")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backAction))
        let isLiked = UserDefaults.standard.bool(forKey: key)
        if isLiked {
            likedButton = UIBarButtonItem(image: UIImage(named: "likedFilled"),
                                          style: .plain, target: self,
                                          action: #selector(likedAction))
            navigationItem.setRightBarButtonItems([likedButton ?? UIBarButtonItem()], animated: false)
            
        } else {
            likedButton = UIBarButtonItem(image: UIImage(named: "likedOutline"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(likedAction))
            navigationItem.setRightBarButtonItems([likedButton ?? UIBarButtonItem()], animated: false)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DishIngredientCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: DishIngredientCell.reuseId)
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        nextButton.titleLabel?.font = nextButton.titleLabel?.font.withSize(18)
        nextButton.addTarget(self,
                             action: #selector(goToStepsAction),
                             for: .touchUpInside)
    }
    
    private func setupWaitingIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createErrorLabel(with errorText: String, and errorButtonText: String) {
        errorStackView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorStackView)
        errorStackView.addArrangedSubview(errorLabel)
        errorStackView.addArrangedSubview(errorButton)
        
        NSLayoutConstraint.activate([
            errorStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorStackView.trailingAnchor, constant: 0),
            errorLabel.leadingAnchor.constraint(equalTo: errorStackView.leadingAnchor),
            errorButton.trailingAnchor.constraint(equalTo: errorStackView.trailingAnchor, constant: 0),
            errorButton.leadingAnchor.constraint(equalTo: errorStackView.leadingAnchor, constant: 0)
        ])
        
        errorLabel.text = errorText
        
        errorLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        
        errorButton.setTitle(errorButtonText, for: .normal)
        errorButton.setTitleColor(UIColor(named: "mainColor"), for: .normal)
        errorButton.layer.cornerRadius = 10
        errorButton.layer.borderWidth = 1
        errorButton.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        errorStackView.axis = .vertical
        errorStackView.spacing = 30
        errorStackView.distribution = .fill
        errorStackView.alignment = .center
        errorButton.addTarget(self, action: #selector(fetchDish), for: .touchUpInside)
        errorStackView.isHidden = false
        errorLabel.isHidden = false
        errorButton.isHidden = false
        
    }
}

//MARK: - Actions
extension DishViewController {
    @objc
    private func backAction() {
        back?()
    }
    
    @objc
    private func likedAction() {
        if UserDefaults.standard.bool(forKey: key) {
            likedButton?.image = UIImage(named: "likedOutline")
            viewModel?.deletLikedImage(key: key)
        } else {
            likedButton?.image = UIImage(named: "likedFilled")
            viewModel?.uploadLikedDish(key: key)
        }
    }
    
    @objc
    private func goToStepsAction() {
        nextAction?(key)
    }
    
    @objc
    private func fetchDish() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {[weak self] path in
            guard let `self` = self else { return }
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.setupWaitingIndicator()
                    self.errorStackView.isHidden = true
                    self.errorLabel.isHidden = true
                    self.errorButton.isHidden = true
                }
                DishWithIngredientsNetworkManager.fetchDishWithIngredients(key: self.key) {[weak self] result in
                    switch result {
                    case .success(let viewModel):
                        DispatchQueue.main.async {
                            self?.viewModel = viewModel
                            guard let imageUrl = URL(string: self?.viewModel?.dish.imageString ?? "") else { return }
                            let resourceForImage = ImageResource(downloadURL: imageUrl,
                                                                 cacheKey: self?.viewModel?.dish.imageString)
                            self?.imageForHeaderView.contentMode = .scaleAspectFill
                            self?.imageForHeaderView.clipsToBounds = true
                            self?.navigationController?.isNavigationBarHidden = false
                            self?.imageForHeaderView.kf.setImage(with: resourceForImage,
                                                                 placeholder: UIImage(named: "DishPlaceHolder"))
                            self?.activityIndicator.stopAnimating()
                            self?.activityIndicator.isHidden = true
                            self?.tableView.isHidden = false
                            
                            if viewModel.checkLikeFunctional() {
                                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                            } else {
                                self?.navigationItem.rightBarButtonItem?.isEnabled = false
                            }
                            self?.tableView.reloadData()
                            monitor.cancel()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            if let error = error as? AppErrors {
                                switch error {
                                case .noInternetConnection:
                                    self?.tableView.isHidden = true
                                    self?.activityIndicator.isHidden = true
                                    self?.navigationController?.isNavigationBarHidden = true
                                    self?.activityIndicator.stopAnimating()
                                    self?.createErrorLabel(with: "Нет сети", and: "Обновить")
                                default:
                                    self?.tableView.isHidden = true
                                    self?.activityIndicator.isHidden = true
                                    self?.activityIndicator.stopAnimating()
                                    self?.createErrorLabel(with: "Неизвестная ошибка", and: "Обновить")
                                }
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.isHidden = true
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.navigationController?.isNavigationBarHidden = true
                    self.createErrorLabel(with: "Нет сети", and: "Обновить")
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        
        monitor.start(queue: queue)
    }
}
    //MARK: - UITableViewDataSource
    extension DishViewController: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return viewModel?.dish.ingredients.count ?? 0
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let viewModel = viewModel else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DishIngredientCell.reuseId,
                                                           for: indexPath) as? DishIngredientCell else {
                return UITableViewCell()
            }
            switch indexPath.section {
            case 0:
                cell.configureForName(viewModel: viewModel)
                return cell
            case 1:
                cell.configureForStaticLabel()
                return cell
            case 2:
                cell.configureForIngredient(viewModel: viewModel, indexPath: indexPath)
                return cell
            default:
                return UITableViewCell()
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.section {
            case 0:
                return 60
            case 1:
                return 45
            default:
                return 70
            }
        }
        
    }
    //MARK: - UITableViewDelegate
    extension DishViewController: UITableViewDelegate {
        
    }
