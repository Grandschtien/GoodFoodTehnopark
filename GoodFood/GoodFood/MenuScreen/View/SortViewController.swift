//
//  SortViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import UIKit

class SortViewController: UIViewController {
    
    private let exitButton: UIButton = UIButton()
    private let applyButton: UIButton = UIButton()
    private let tableView: UITableView = UITableView()
    
    var close: (() -> Void)?
    
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
        
        switch indexPath.row {
        case 0:
            cell.label.text = "По названию"
        case 1:
            cell.label.text = "По рейтингу"
        case 2:
            cell.label.text = "По времени готовки"
        default:
            break
        }
        
        return cell
    }
    
    
}

//MARK: - TableViewDelegate
extension SortViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SortCell else { return }
        cell.checkMark.isHidden = false
    }
}
