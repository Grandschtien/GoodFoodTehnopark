//
//  MenuViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 30.10.2021.
//

import UIKit
import Firebase
import Network

class MenuViewController: UIViewController {
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var tableView = UITableView()
    private var activityIndicator = UIActivityIndicatorView()
    private let noConnectionLabel = UILabel()
    private let refreshButton = UIButton()
    private let errorLabel = UILabel()
    private let errorButton = UIButton(type: .roundedRect)
    private let errorStackView = UIStackView()
    
    var array: [MenuModel] = []
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: MenuViewModel?
    let transition = PanelTransition()
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var add: (() -> Void)?
    var sort: (() -> Void)?
    var dish: ((String) -> Void)?
    
    init(coordinatror: CoordinatorProtocol) {
        self.coordinator = coordinatror
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
//MARK: - Настройка views
extension MenuViewController {
    private func setupViews(){
        view.backgroundColor = UIColor(named: "BackgroundColor")
        title = "Меню"
        setupNavigationBar()
        setupSearchController()
        setupConstraints()
        setupUI()
        setupTabBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(menuFilterButtonAction))
        let sortButton = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(menuSortButtonAction))
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(menuAddButtonAction))
        navigationItem.setRightBarButtonItems([addButton, sortButton], animated: true)
    }
    private func setupTabBar() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundColor = UIColor(named: "tabBarColor")
    }
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Название"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = view.backgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuCell.reuseId, bundle: nil), forCellReuseIdentifier: MenuCell.reuseId)
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
        errorButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        errorStackView.isHidden = false
        errorLabel.isHidden = false
        errorButton.isHidden = false
        
    }
}
//MARK: - Actions
extension MenuViewController {
    @objc
    private func menuFilterButtonAction() {
        
    }
    @objc
    private func menuSortButtonAction() {
        sort?()
    }
    @objc
    private func menuAddButtonAction() {
        add?()
    }
    @objc
    fileprivate func fetchData() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {[weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.setupWaitingIndicator()
                    self?.errorStackView.isHidden = true
                    self?.errorLabel.isHidden = true
                    self?.errorButton.isHidden = true
                }
                MenuNetworkService.fetchDishes{[weak self] response in
                    switch response {
                    case .success(let viewModel):
                        DispatchQueue.main.async {
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
}
//MARK: - UISearchResultsUpdating
extension MenuViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String) {
        array = viewModel?.dishes.filter { (dish: MenuModel) -> Bool in
            return dish.name.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

//MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return array.count
        }
        return viewModel?.dishes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell,
              let viewModel = viewModel
        else { return UITableViewCell() }
        
        let filteredDish: MenuModel
        
        if isFiltering {
            filteredDish = array[indexPath.row]
            cell.configure(with: filteredDish)
        } else {
            cell.configure(with: viewModel, for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 342
    }
    
}
//MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dishKey = viewModel?.dishes[indexPath.row].key else {return}
        dish?(dishKey)
    }
}
