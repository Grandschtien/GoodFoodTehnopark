//
//  IngredientCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit

class DishIngredientCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let reuseId = "DishIngredientCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
    }
    
    func configureForIngredient(viewModel: DishViewModel, indexPath: IndexPath) {
        nameLabel.font = nameLabel.font.withSize(20)
        nameLabel.text = "\(viewModel.dish.ingredients[indexPath.row].name), \(viewModel.dish.ingredients[indexPath.row].amount)"
    }
    
    func configureForName(viewModel: DishViewModel) {
        nameLabel.font = nameLabel.font.withSize(25)
        nameLabel.text = viewModel.dish.name
        nameLabel.textAlignment = .center
        containerView.backgroundColor = .none
    }
    
    func configureForStaticLabel() {
        nameLabel.font = nameLabel.font.withSize(17)
        self.backgroundColor = .none
        nameLabel.backgroundColor = .none
        nameLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        nameLabel.text = "Ингредиенты"
        nameLabel.textAlignment = .center
        containerView.backgroundColor = .none
    }
}
