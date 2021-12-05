//
//  DishViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit

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
    
    var back: (() -> Void)?
    var nextAction: (() -> Void)?
    private var isLiked = false
    
    init(viewModel: DishViewModel, coordinatror: CoordinatorProtocol) {
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
        tableView.register(UINib(nibName: IngredientCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: IngredientCell.reuseId)
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        imageForHeaderView.image = UIImage(named: "test")
        imageForHeaderView.contentMode = .scaleAspectFill
        nextButton.titleLabel?.font = nextButton.titleLabel?.font.withSize(18)
        nextButton.addTarget(self, action: #selector(goToStepsAction), for: .touchUpInside)
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
        nextAction?()
    }
}
//MARK: - UITableViewDataSource
extension DishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell()}
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DishIngredientCell.reuseId,
                                                           for: indexPath) as? DishIngredientCell else {
                return UITableViewCell()
            }
            cell.configureForName(viewModel: viewModel)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DishIngredientCell.reuseId,
                                                           for: indexPath) as? DishIngredientCell else {
                return UITableViewCell()
            }
            cell.configureForStaticLabel()
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DishIngredientCell.reuseId,
                                                           for: indexPath) as? DishIngredientCell else {
                return UITableViewCell()
            }
            cell.configureForIngredient(viewModel: viewModel, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 45
        case 1:
            return 45
        default:
            return 50
        }
    }
    
}
//MARK: - UITableViewDelegate
extension DishViewController: UITableViewDelegate {
    
}
