//
//  MenuViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 30.10.2021.
//

import UIKit

class MenuViewController: UIViewController {

    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    private var tableView: UITableView = UITableView()
    private var coordinator: CoordinatorProtocol?
    private(set) var viewModel: MenuViewModel?
    
    init(viewModel: MenuViewModel, coordinatror: CoordinatorProtocol) {
        self.coordinator = coordinatror
        self.viewModel = viewModel
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: 0)
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
}
//MARK: - Actions
extension MenuViewController {
    @objc
    private func menuFilterButtonAction() {
        
    }
    @objc
    private func menuSortButtonAction() {
        
    }
    @objc
    private func menuAddButtonAction() {
        
    }
}
//MARK: - UISearchResultsUpdating
extension MenuViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

//MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell else { return UITableViewCell() }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
//MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {

}
