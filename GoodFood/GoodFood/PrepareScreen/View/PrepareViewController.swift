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
    
    var back: (() -> Void)?
    var exit: (() -> Void)?
    
    init(viewModel: PrepareViewModel, coordinatror: CoordinatorProtocol) {
        self.coordinator = coordinatror
        self.viewModel = viewModel
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        
        switch indexPath.row {
        case totalRows - 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseId) as? RatingCell else {
                return UITableViewCell()
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCell.reuseId, for: indexPath) as? StepCell
            else {
                return UITableViewCell()
            }
            
            cell.configure(viewModel: viewModel)
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
