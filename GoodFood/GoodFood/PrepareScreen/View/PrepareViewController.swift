//
//  PrepareViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit

class PrepareViewController: UIViewController {
    
    private let tableView = UITableView()
    private var footerView: UIView?
    private let exitButton = MainButton(color: UIColor(named: "mainColor"), title: "Завершить")
    
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
        setupConstraints()
        fetchSteps()
        setupUI()
    }
    
    private func fetchSteps() {
        PrepareScreenNetworkManager.fetchDishSteps(key: key) {[weak self] result in
            switch result {
            case .success(let viewModel):
                DispatchQueue.main.async {
                    self?.viewModel = viewModel
                    print (viewModel.steps.steps.count)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}


extension PrepareViewController {
    
    private func setupConstraints() {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        footerView?.addSubview(exitButton)
        tableView.tableFooterView = footerView
        
        exitButton.topAnchor.constraint(equalTo: footerView!.topAnchor,
                                        constant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: footerView!.trailingAnchor,
                                             constant: -25).isActive = true
        exitButton.leadingAnchor.constraint(equalTo: footerView!.leadingAnchor,
                                            constant: 25).isActive = true
        
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
        exit?()
    }
}
