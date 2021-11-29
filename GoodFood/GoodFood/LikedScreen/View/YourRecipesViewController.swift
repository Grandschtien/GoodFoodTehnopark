//
//  YourRecipesViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 12.11.2021.
//

import UIKit

class YourRecipesViewController: UIViewController {

    private let tableView = UITableView()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: YourRecipesViewModel?
    
    
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
        
    }
    
    
}

extension YourRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell else { return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension YourRecipesViewController: UITableViewDelegate {
   
}
