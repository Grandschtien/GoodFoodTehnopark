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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}
//MARK: - Настройка views
extension MenuViewController {
    private func setupViews(){
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        self.title = "Меню"
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupTabBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(menuFilterButtonAction))
        let sortButton = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(menuSortButtonAction))
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(menuAddButtomAction))
        navigationItem.setRightBarButtonItems([addButton, sortButton], animated: true)
    }
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "tabBarColor")
    }
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Блюдо или ингредиент"
        navigationItem.searchController = searchController
        definesPresentationContext = true
       
    }
    
    private func setupTableView() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: MenuCell.reuseId, bundle: nil), forCellReuseIdentifier: MenuCell.reuseId)
        self.view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                            constant: 0).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                               constant: 0).isActive = true
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
    private func menuAddButtomAction() {
        
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
        return 342
    }

}
//MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {

}
