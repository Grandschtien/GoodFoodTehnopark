//
//  SortViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import UIKit

protocol ReloadData: AnyObject {
    func reloadAfterSort(sortedDishes: [MenuModel])
}

class SortViewController: UIViewController {
    
    private let exitButton = UIButton()
    private let applyButton = MainButton(color: UIColor(named: "mainColor"), title: "Применить")
    private let tableView = UITableView()
    private var viewModel: SortViewModel?
    weak var delegate: ReloadData?
    
    var previousIndex: IndexPath?
    
    var close: (() -> Void)?
    var apply: (([MenuModel]) -> Void)?
    
    init(viewModel: SortViewModel) {
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
//MARK: - Constraints and UI
extension SortViewController {
    func setupConstraints() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 30),
            exitButton.heightAnchor.constraint(equalToConstant: 30),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -13),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: 8)
        ])
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -56),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: 56),
            applyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                constant: -40),
            applyButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor,
                                           constant: 60),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor,
                                              constant: -10)
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: SortCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: SortCell.reuseId)
        tableView.isScrollEnabled = false
        exitButton.setImage(UIImage(named: "close"), for: .normal)
        exitButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        applyButton.setTitle("Применить", for: .normal)
        applyButton.backgroundColor = UIColor(named: "mainColor")
        applyButton.layer.cornerRadius = 20
        applyButton.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
    }
}
//MARK: - Actions
extension SortViewController {
    @objc
    private func closeAction() {
        close?()
    }
    
    @objc
    private func applyAction() {
        if let sortedBy = viewModel?.sortedBy {
            switch sortedBy {
            case .ratingDown:
                apply?(viewModel?.sortedByRatingDown ?? [])
            case .nameAZ:
                apply?(viewModel?.sortedByNameDishesAZ ?? [])
            case .nameZA:
                apply?(viewModel?.sortedByNameDishesZA ?? [])
            }
        } else {
            apply?(viewModel?.unSortedDishes ?? [])
        }
        
    }
}

//MARK: - TableViewDataSource
extension SortViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortCell.reuseId, for: indexPath) as? SortCell else { return UITableViewCell()}
        
        cell.configure(with: indexPath)
        
        return cell
    }
    
    
}

//MARK: - TableViewDelegate
extension SortViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? SortCell else {
            return
        }
        
        if let previousIndex = previousIndex, let previousCell = tableView.cellForRow(at: previousIndex) as? SortCell {
            previousCell.isSelectedCell = false
        }
        if selectedCell.isSelectedCell {
            viewModel?.sortedBy = nil
            selectedCell.isSelectedCell = !selectedCell.isSelectedCell
        } else {
            switch indexPath.row {
            case 0:
                viewModel?.sort(with: .nameAZ)
            case 1:
                viewModel?.sort(with: .nameZA)
            case 2:
                viewModel?.sort(with: .ratingDown)
            default:
                break
            }
            previousIndex = indexPath
            selectedCell.isSelectedCell = !selectedCell.isSelectedCell
        }
    }
    
}
