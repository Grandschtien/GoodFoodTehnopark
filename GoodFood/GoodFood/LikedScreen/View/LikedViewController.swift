//
//  LikedViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 31.10.2021.
//

import UIKit

class LikedViewController: UIViewController {
    
    private let tableView = UITableView()
    private var activityIndicator = UIActivityIndicatorView()

    private var coordinator: CoordinatorProtocol?
    private var viewModel: LikedViewModel?
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
        setupConstraints()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tabBarController?.tabBar.isHidden = false
    }
}

extension LikedViewController {
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
        
    }
    
    private func fetchData() {
        LikedNetworkManager.fetchDishes {[weak self] result in
            switch result {
            case .success(let viewModel):
                DispatchQueue.main.async {
                    self?.viewModel = viewModel
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
    
}

extension LikedViewController: UITableViewDataSource {
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
        cell.configureForLikedScreen(with: viewModel, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 342
    }
    
    
}

extension LikedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dishKey = viewModel?.dishes[indexPath.row].key else {
            return
        }
        dish?(dishKey)
    }
}


