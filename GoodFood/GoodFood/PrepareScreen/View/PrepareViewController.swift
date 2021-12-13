//
//  PrepareViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit
import Network 
import SwiftUI
class PrepareViewController: UIViewController {
    
    private let tableView = UITableView()
    private var footerView: UIView?
    private let exitButton = MainButton(color: UIColor(named: "mainColor"), title: "Завершить")
    private var activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    private let errorButton = UIButton(type: .roundedRect)
    private let errorStackView = UIStackView()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: PrepareViewModel?
    private var key: String
    
    var back: (() -> Void)?
    var exit: (() -> Void)?
    
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
        print(key)
        setupConstraints()
        fetchSteps()
        setupUI()
    }
    @objc
    private func fetchSteps() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {[weak self] path in
            guard let`self` = self else {return}
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.setupWaitingIndicator()
                    self.errorStackView.isHidden = true
                    self.errorLabel.isHidden = true
                    self.errorButton.isHidden = true
                }
                PrepareScreenNetworkManager.fetchDishSteps(key: self.key) {[weak self] result in
                    switch result {
                    case .success(let viewModel):
                        if viewModel != nil {
                            self?.viewModel = viewModel
                            self?.activityIndicator.stopAnimating()
                            self?.tableView.isHidden = false
                            self?.activityIndicator.isHidden = true
                            self?.tableView.reloadData()
                            monitor.cancel()
                        } else {
                            self?.tableView.isHidden = true
                            self?.activityIndicator.isHidden = true
                            self?.activityIndicator.stopAnimating()
                            self?.createErrorLabel(with: "Нет сети", and: "Обновить")
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            if let error = error as? AppErrors {
                                switch error {
                                case .noInternetConnection:
                                    self?.tableView.isHidden = true
                                    self?.activityIndicator.isHidden = true
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
                    self.createErrorLabel(with: "Нет сети", and: "Обновить")
                }
            }
            
        }
        let queue = DispatchQueue(label: "Network")
        
        monitor.start(queue: queue)
    }
    
}


extension PrepareViewController {
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
        errorButton.addTarget(self, action: #selector(fetchSteps), for: .touchUpInside)
        errorStackView.isHidden = false
        errorLabel.isHidden = false
        errorButton.isHidden = false
        
    }
    private func setupConstraints() {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        footerView?.addSubview(exitButton)
        tableView.tableFooterView = footerView
        
        exitButton.topAnchor.constraint(equalTo: footerView!.topAnchor,
                                        constant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: footerView!.trailingAnchor,
                                             constant: -24).isActive = true
        exitButton.leadingAnchor.constraint(equalTo: footerView!.leadingAnchor,
                                            constant: 24).isActive = true
        
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
        view.backgroundColor = UIColor(named: "BackgroundColor")
        title = "Приготовление"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: StepCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: StepCell.reuseId)
        tableView.register(UINib(nibName: RatingCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: RatingCell.reuseId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backAction))
        exitButton.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
    }
    
}
extension PrepareViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return viewModel?.steps.steps.count ?? 0
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        //        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        
        switch indexPath.section {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseId) as? RatingCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCell.reuseId, for: indexPath) as? StepCell
            else {
                return UITableViewCell()
            }
            cell.configure(viewModel: viewModel, indexPath: indexPath)
            return cell
        }
    }
    
    
}
extension PrepareViewController: UITableViewDelegate {
    
}
extension PrepareViewController {
    @objc
    func backAction() {
        back?()
    }
    
    @objc
    func exitAction() {
        viewModel?.uploadFinishingRecipe(key: key)
        exit?()
    }
}

extension PrepareViewController: RatingCellProtocol {
    func pushRating(rating: Double) {
        viewModel?.updateRating(dishForkey: key, rating: rating)
    }
}
