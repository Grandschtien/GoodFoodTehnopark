//
//  DishViewControllerCD.swift
//  GoodFood
//
//  Created by Иван on 15.12.2021.
//

import UIKit
import Kingfisher
import Network

class DishViewControllerCD: UIViewController {
    
    private let tableView = ParalaxTableView()
    private var headerView: UIView?
    private var footerView: UIView?
    private let imageForHeaderView = UIImageView()
    private let nextButton = MainButton(color: UIColor(named: "mainColor"), title: "Перейти к готовке")
    private var activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    private let errorButton = UIButton(type: .roundedRect)
    private let errorStackView = UIStackView()
    
    private var likedButton: UIBarButtonItem?
    var imageHeightConstraint: NSLayoutConstraint?
    var imageBottomConstraint: NSLayoutConstraint?
    var imageLeadingConstraint: NSLayoutConstraint?
    var imageTrailingConstraint: NSLayoutConstraint?
    
    private var coordinator: CoordinatorProtocol?
    private let name: RecipeCD?
    private var ingredients: [IngredientCD] = []
    private let dataBaseManager: DataManager = DataManager.shared
    
    var back: (() -> Void)?
    var nextAction: ((RecipeCD) -> Void)?
    
    init(name: RecipeCD?, coordinatror: CoordinatorProtocol) {
        self.coordinator = coordinatror
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.name = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        setupWaitingIndicator()
        setupConstraints()
        fetchDish()
        setupUI()
    }
}

extension DishViewControllerCD {
    
    private func setupConstraints() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        imageForHeaderView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        footerView?.addSubview(nextButton)
        headerView?.addSubview(imageForHeaderView)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        nextButton.topAnchor.constraint(equalTo: footerView!.topAnchor, constant: 20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: footerView!.trailingAnchor, constant: -25).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: footerView!.leadingAnchor, constant: 25).isActive = true
        
        imageBottomConstraint = NSLayoutConstraint(item: headerView ?? UIView(),
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem:  imageForHeaderView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
        
        imageHeightConstraint = NSLayoutConstraint(item: imageForHeaderView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 200)
        
        imageLeadingConstraint = NSLayoutConstraint(item: headerView ?? UIView(),
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: imageForHeaderView,
                                                    attribute: .leading,
                                                    multiplier: 1,
                                                    constant: 0)
        
        imageTrailingConstraint = NSLayoutConstraint(item: headerView ?? UIView(),
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: imageForHeaderView,
                                                     attribute: .trailing,
                                                     multiplier: 1,
                                                     constant: 0)
        
        imageHeightConstraint?.isActive = true
        imageBottomConstraint?.isActive = true
        imageLeadingConstraint?.isActive = true
        imageTrailingConstraint?.isActive = true
        
        imageBottomConstraint?.identifier = "imageBottomConstraint"
        imageHeightConstraint?.identifier = "imageHeightConstraint"
        
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
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = UIColor(named: "BackgroundColor")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backAction))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DishIngredientCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: DishIngredientCell.reuseId)
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        nextButton.titleLabel?.font = nextButton.titleLabel?.font.withSize(18)
        nextButton.addTarget(self,
                             action: #selector(goToStepsAction),
                             for: .touchUpInside)
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
        errorButton.addTarget(self, action: #selector(fetchDish), for: .touchUpInside)
        errorStackView.isHidden = false
        errorLabel.isHidden = false
        errorButton.isHidden = false
        
    }
}

//MARK: - Actions
extension DishViewControllerCD {
    @objc
    private func backAction() {
        back?()
    }
    
    @objc
    private func goToStepsAction() {
        guard let recipe = name else {
            return
        }
        nextAction?(recipe)
    }
    
    @objc
    private func fetchDish() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
        if let imageData = name?.image {
            imageForHeaderView.image = UIImage(data: imageData, scale: 1.0)
            self.imageForHeaderView.contentMode = .scaleAspectFill
            self.imageForHeaderView.clipsToBounds = true
        } else {
            imageForHeaderView.image = UIImage(named: "DishPlaceHolder")
            self.imageForHeaderView.contentMode = .scaleAspectFill
            self.imageForHeaderView.clipsToBounds = true
        }
        guard let recipe = name else {
            return
        }
        ingredients = dataBaseManager.fetchIngredientsForRecipe(recipe: recipe)
    }
}
    //MARK: - UITableViewDataSource
    extension DishViewControllerCD: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return ingredients.count
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DishIngredientCell.reuseId,
                                                           for: indexPath) as? DishIngredientCell else {
                return UITableViewCell()
            }
            switch indexPath.section {
            case 0:
                guard let recipe = name else {
                    return UITableViewCell()
                }
                cell.configureForNameCD(recipe: recipe)
                return cell
            case 1:
                cell.configureForStaticLabel()
                return cell
            case 2:
                guard let recipe = name else {
                    return UITableViewCell()
                }
                cell.configureForIngredientCD(ingredient: ingredients[indexPath.row], indexPath: indexPath)
                return cell
            default:
                return UITableViewCell()
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.section {
            case 0:
                return 60
            case 1:
                return 45
            default:
                return 70
            }
        }
        
    }
    //MARK: - UITableViewDelegate
    extension DishViewControllerCD: UITableViewDelegate {
        
    }

