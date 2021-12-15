//
//  PrepareViewControllerCD.swift
//  GoodFood
//
//  Created by Иван on 15.12.2021.
//

import UIKit
import Network
import SwiftUI
class PrepareViewControllerCD: UIViewController {
    
    private let tableView = UITableView()
    private var footerView: UIView?
    private let exitButton = MainButton(color: UIColor(named: "mainColor"), title: "Завершить")
    private var activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    private let errorButton = UIButton(type: .roundedRect)
    private let errorStackView = UIStackView()
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: PrepareViewModel?
    private var recipe: RecipeCD?
    
    private var stages: [StageCD] = []
    private let dataBaseManager: DataManager = DataManager.shared
    
    var back: (() -> Void)?
    var exit: (() -> Void)?
    
    init(recipe: RecipeCD, coordinatror: CoordinatorProtocol) {
        self.coordinator = coordinatror
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.recipe = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        fetchSteps()
        setupUI()
    }
    @objc
    private func fetchSteps() {
        guard let recipe = recipe else {
            return
        }
        stages = dataBaseManager.fetchStagesForRecipe(recipe: recipe)
    }
    
}


extension PrepareViewControllerCD {
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
    private func createErrorLabel(with errorText: String, and errorButtonText: String) {
        errorStackView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorStackView)
        errorStackView.addArrangedSubview(errorLabel)
        errorStackView.addArrangedSubview(errorButton)
        
        NSLayoutConstraint.activate([
            errorStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorStackView.trailingAnchor, constant: 0),
            errorLabel.leadingAnchor.constraint(equalTo: errorStackView.leadingAnchor),
            errorButton.trailingAnchor.constraint(equalTo: errorStackView.trailingAnchor, constant: 0),
            errorButton.leadingAnchor.constraint(equalTo: errorStackView.leadingAnchor, constant: 0)
        ])
        
        errorLabel.text = errorText
        
        errorLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        
        errorButton.setTitle(errorButtonText, for: .normal)
        errorButton.setTitleColor(UIColor(named: "mainColor"), for: .normal)
        errorButton.layer.cornerRadius = 10
        errorButton.layer.borderWidth = 1
        errorButton.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        errorStackView.axis = .vertical
        errorStackView.spacing = 30
        errorStackView.distribution = .fill
        errorStackView.alignment = .center
        errorButton.addTarget(self, action: #selector(fetchSteps), for: .touchUpInside)
        errorStackView.isHidden = false
        errorLabel.isHidden = false
        errorButton.isHidden = false
        
    }
    private func setupConstraints() {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        footerView?.addSubview(exitButton)
        tableView.tableFooterView = footerView
        
        exitButton.topAnchor.constraint(equalTo: footerView!.topAnchor,
                                        constant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: footerView!.trailingAnchor,
                                             constant: -24).isActive = true
        exitButton.leadingAnchor.constraint(equalTo: footerView!.leadingAnchor,
                                            constant: 24).isActive = true
        
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
extension PrepareViewControllerCD: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCell.reuseId, for: indexPath) as? StepCell
        else {
            return UITableViewCell()
        }
        cell.configureCD(stage: stages[indexPath.row])
        return cell
    }
    
    
}
extension PrepareViewControllerCD: UITableViewDelegate {
    
}
extension PrepareViewControllerCD {
    @objc
    func backAction() {
        back?()
    }
    
    @objc
    func exitAction() {
        exit?()
    }
}


