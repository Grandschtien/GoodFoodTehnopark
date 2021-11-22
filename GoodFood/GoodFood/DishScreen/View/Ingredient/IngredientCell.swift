//
//  IngredientCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit

class IngredientCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let reuseId = "IngredientCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
    }
    
    func configureForIngredient(viewModel: DishViewModel, indexPath: IndexPath) {
        nameLabel.font = nameLabel.font.withSize(20)
        nameLabel.text = "Row: \(indexPath.row)"
    }
    
    func configureForName(viewModel: DishViewModel) {
        nameLabel.font = nameLabel.font.withSize(25)
        // TODO: Сделать через viewModel.dish.name
        nameLabel.text = "Название"
        nameLabel.textAlignment = .center
        containerView.backgroundColor = .none
    }
    
    func configureForStaticLabel() {
        nameLabel.font = nameLabel.font.withSize(17)
        nameLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
        nameLabel.text = "Ингредиенты"
        nameLabel.textAlignment = .center
        containerView.backgroundColor = .none
    }
}
