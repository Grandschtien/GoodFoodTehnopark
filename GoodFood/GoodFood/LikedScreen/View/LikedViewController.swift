//
//  LikedViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 31.10.2021.
//

import UIKit

class LikedViewController: UIViewController {
    
    private let segmentControl = UISegmentedControl(items: ["Избранное",
                                                            "Ваши рецепты",
                                                            "История"])
    private let tableView: UITableView = UITableView()
    
    private var coordinator: CoordinatorProtocol?
    private(set) var viewModel: LikedViewModel?
    
    
    init(viewModel: LikedViewModel, coordinator: CoordinatorProtocol) {
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

extension LikedViewController {
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: 0)
        ])
    }
    
    private func setupUI() {
        navigationItem.titleView = segmentControl
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self,
                                 action: #selector(segmentIndexChenged(_:)),
                                 for: .valueChanged)
        
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

extension LikedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 10
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

extension LikedViewController: UITableViewDelegate {
    
}

extension LikedViewController {
    @objc
    private func segmentIndexChenged(_ segmntedControl: UISegmentedControl) {
        print(segmntedControl.selectedSegmentIndex)
    }
}
