//
//  YourRecipesViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 12.11.2021.
//

import UIKit

//protocol InsertData {
//    func insertData(recipe: RecipeCD)
//}

class YourRecipesViewController: UIViewController {

    private let tableView = UITableView()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: YourRecipesViewModel?
    
    private var dataSource: [RecipeCD] = []
    
    private let dataBaseManager: DataManager = DataManager.shared
    
    var dish: ((RecipeCD) -> Void)?
    
    init(viewModel: YourRecipesViewModel, coordinator: CoordinatorProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
}

extension YourRecipesViewController {
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testCell")
        
    }
    
    private func fetch() {
        dataSource = dataBaseManager.fetch()
        tableView.reloadData()
    }
    
}

extension YourRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell else { return UITableViewCell()}
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") else {
//            return UITableViewCell()
//        }
        
        let recipe = dataSource[indexPath.row]
        cell.configureForYourRecipesScreen(recipe: recipe)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 342
    }
    
    
}

extension YourRecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dish?(dataSource[indexPath.row])
    }
}
