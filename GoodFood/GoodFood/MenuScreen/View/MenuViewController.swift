//
//  MenuViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 30.10.2021.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    private var searchController = UISearchController(searchResultsController: nil)
    private var tableView = UITableView()
    private var activityIndicator = UIActivityIndicatorView()
    private let noConnectionLabel = UILabel()
    private let refreshButton = UIButton()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: MenuViewModel?
    let transition = PanelTransition() 
    
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
        searchController.searchBar.placeholder = "Блюдо или ингредиент"
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
        setupWaitingIndicator()
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
    
    private func setupNoConnectionLabel() {
        let noConnectionStackView = UIStackView()
        noConnectionStackView.addArrangedSubview(noConnectionLabel)
        noConnectionStackView.addArrangedSubview(refreshButton)
        view.addSubview(noConnectionStackView)
        NSLayoutConstraint.activate([
            noConnectionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noConnectionStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noConnectionLabel.leadingAnchor.constraint(equalTo: noConnectionStackView.leadingAnchor),
            noConnectionLabel.trailingAnchor.constraint(equalTo: noConnectionStackView.trailingAnchor),
            refreshButton.leadingAnchor.constraint(equalTo: noConnectionStackView.leadingAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: noConnectionStackView.trailingAnchor)
        ])
        noConnectionStackView.axis = .vertical
        noConnectionStackView.spacing = 8
        noConnectionStackView.alignment = .center
        
        noConnectionLabel.text = "Нет интернет соединения. Пожалуйста, проверьте подключение к сети и нажмите кнопку Обновить"
        noConnectionLabel.numberOfLines = 0
        refreshButton.setTitle("Обновить", for: .normal)
        refreshButton.tintColor = .blue
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
}
//MARK: - UISearchResultsUpdating
extension MenuViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    fileprivate func fetchData() {
        MenuNetworkService.fetchDishes{[weak self] response in
            switch response {
            case .success(let viewModel):
                DispatchQueue.main.async {
                    self?.viewModel = viewModel
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.tableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.setupNoConnectionLabel()
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dishes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell,
              let viewModel = viewModel
        else { return UITableViewCell() }
        cell.configure(with: viewModel, for: indexPath)
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
