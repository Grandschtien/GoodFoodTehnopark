//
//  MenuViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 30.10.2021.
//

import UIKit

class MenuViewController: UIViewController {

    private var searchController = UISearchController(searchResultsController: nil)
    private var tableView = UITableView()
    private var coordinator: CoordinatorProtocol?
    private var viewModel: MenuViewModel?
    let transition = PanelTransition() 
    
    var add: (() -> Void)?
    var sort: (() -> Void)?
    var dish: (() -> Void)?
    
    init(viewModel: MenuViewModel, coordinatror: CoordinatorProtocol) {
        self.coordinator = coordinatror
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel?.fetchDishes(completion: { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.tableView.isHidden = true
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        
    }
    
    private func setupNoConnectionLabel() {
        
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
}

//MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dishes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell else { return UITableViewCell()
        }
        cell.configure(with: viewModel?.dishes?[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
//MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dish?()
    }
}
