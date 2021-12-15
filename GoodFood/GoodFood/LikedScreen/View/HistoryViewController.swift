//
//  HistoryViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 12.11.2021.
//

import UIKit
import Network
class HistoryViewController: UIViewController {

    private let tableView = UITableView()
    private var activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    private let errorButton = UIButton(type: .roundedRect)
    private let errorStackView = UIStackView()
    private let refreshControl = UIRefreshControl()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: HistoryViewModel?
    var dish: ((String) -> Void)?
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(indicatorIsNeed: true)
        setupConstraints()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        tabBarController?.tabBar.isHidden = false 
    }
}

extension HistoryViewController {
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        setupWaitingIndicator()
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: MenuCell.reuseId)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateTable(sender:)), for: .valueChanged)
    }
    @objc
    private func updateTable(sender: UIRefreshControl) {
        fetchData(indicatorIsNeed: false)
        sender.endRefreshing()
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
    
    @objc
    private func fetchData(indicatorIsNeed: Bool) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {[weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    if indicatorIsNeed {
                        self?.setupWaitingIndicator()
                    }
                    self?.errorStackView.isHidden = true
                    self?.errorLabel.isHidden = true
                    self?.errorButton.isHidden = true
                }
                
                HistoryNetworkManager.fetchDishes {[weak self] result in
                    switch result {
                    case .success(let viewModel):
                        DispatchQueue.main.async {
                            self?.viewModel = viewModel
                            
                            self?.tableView.isHidden = false
                            self?.activityIndicator.stopAnimating()
                            self?.activityIndicator.isHidden = true
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
                                    self?.activityIndicator.stopAnimating()
                                    self?.createErrorLabel(with: "Нет сети", and: "Обновить")
                                case .clientInGuestMode:
                                    self?.tableView.isHidden = true
                                    self?.activityIndicator.isHidden = true
                                    self?.activityIndicator.stopAnimating()
                                    self?.createErrorLabel(with: "Вы в гостевом режиме", and: "Войти")
                                default:
                                    self?.tableView.isHidden = true
                                    self?.activityIndicator.isHidden = true
                                    self?.activityIndicator.stopAnimating()
                                    self?.createErrorLabel(with: "Здесь пока ничего нет", and: "Обновить")
                                }
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.tableView.isHidden = true
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    self?.createErrorLabel(with: "Нет сети", and: "Обновить")
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        
        monitor.start(queue: queue)
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
        errorButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        errorStackView.isHidden = false
        errorLabel.isHidden = false
        errorButton.isHidden = false
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dishes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell,
              let viewModel = viewModel
        else { return UITableViewCell()}
        cell.configureForHistoryScreen(with: viewModel, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 342
    }
    
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dishKey = viewModel?.dishes[indexPath.row].key else {
            return
        }
        dish?(dishKey)
    }
}
