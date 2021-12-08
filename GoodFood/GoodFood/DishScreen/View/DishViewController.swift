//
//  DishViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit
import Kingfisher


class DishViewController: UIViewController {
    
    private let tableView = ParalaxTableView()
    private var headerView: UIView?
    private var footerView: UIView?
    private let imageForHeaderView = UIImageView()
    private let nextButton = MainButton(color: UIColor(named: "mainColor"), title: "Перейти к готовке")
    var imageHeightConstraint: NSLayoutConstraint?
    var imageBottomConstraint: NSLayoutConstraint?
    var imageLeadingConstraint: NSLayoutConstraint?
    var imageTrailingConstraint: NSLayoutConstraint?
    
    private var coordinator: CoordinatorProtocol?
    private var viewModel: DishViewModel?
    private let key: String
    
    var back: (() -> Void)?
    var nextAction: ((String) -> Void)?
    private var isLiked = false
    
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
        fetchDish()
        setupUI()
    }
}

extension DishViewController {
    
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
        let likedButton = UIBarButtonItem(image: UIImage(named: "likedOutline"),
                                          style: .done,
                                          target: self,
                                          action: #selector(likedAction))
        navigationItem.setRightBarButtonItems([likedButton], animated: false)
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
}

//MARK: - Actions
extension DishViewController {
    @objc
    private func backAction() {
        back?()
    }
    
    @objc
    private func likedAction() {
        if isLiked {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "likedOutline")
            isLiked = !isLiked
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "likedFilled")
            isLiked = !isLiked
        }
    }
    
    @objc
    private func goToStepsAction() {
        nextAction?(key)
    }
    
    private func fetchDish() {
        DishWithIngredientsNetworkManager.fetchDishWithIngredients(key: key) {[weak self] result in
            switch result {
            case .success(let viewModel):
                DispatchQueue.main.async {
                    self?.viewModel = viewModel
                    guard let imageUrl = URL(string: self?.viewModel?.dish.imageString ?? "") else { return }
                    let resourceForImage = ImageResource(downloadURL: imageUrl,
                                                         cacheKey: self?.viewModel?.dish.imageString)
                    self?.imageForHeaderView.contentMode = .scaleAspectFill
                    self?.imageForHeaderView.clipsToBounds = true
                    self?.imageForHeaderView.kf.setImage(with: resourceForImage,
                                                         placeholder: UIImage(named: "DishPlaceHolder"))
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
//MARK: - UITableViewDataSource
extension DishViewController: UITableViewDataSource {
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
            return viewModel?.dish.ingredients.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DishIngredientCell.reuseId,
                                                       for: indexPath) as? DishIngredientCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.configureForName(viewModel: viewModel)
            return cell
        case 1:
            cell.configureForStaticLabel()
            return cell
        case 2:
            cell.configureForIngredient(viewModel: viewModel, indexPath: indexPath)
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
extension DishViewController: UITableViewDelegate {
    
}
