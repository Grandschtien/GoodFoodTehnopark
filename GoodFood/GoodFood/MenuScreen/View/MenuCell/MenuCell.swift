//
//  MenuCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 31.10.2021.
//

import UIKit
import Cosmos
import Kingfisher

class MenuCell: UITableViewCell {
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var containerView: UIView!
    static let reuseId = "MenuCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.masksToBounds = true
        self.ratingView.isUserInteractionEnabled = false
        self.dishImage.contentMode = .scaleAspectFill
        self.timeLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
    }
    
    func configure(with viewModel: MenuViewModel, for indexPath: IndexPath) {
        self.nameLabel.text = viewModel.dishes[indexPath.row].name
        self.timeLabel.text = viewModel.dishes[indexPath.row].cookTime
        self.ratingView.rating = viewModel.dishes[indexPath.row].rating
        guard let imageUrl = URL(string: viewModel.dishes[indexPath.row].image) else { return }
        let resource = ImageResource(downloadURL: imageUrl,
                                     cacheKey: viewModel.dishes[indexPath.row].image)
        self.dishImage.kf.setImage(with: resource, placeholder: UIImage(named: "DishPlaceHolder"))
    }
    
    func configureForLikedScreen(with viewModel: LikedViewModel, for indexPath: IndexPath) {
        self.nameLabel.text = viewModel.dishes[indexPath.row].name
        self.timeLabel.text = viewModel.dishes[indexPath.row].cookTime
        self.ratingView.rating = viewModel.dishes[indexPath.row].rating
        guard let imageUrl = URL(string: viewModel.dishes[indexPath.row].image) else { return }
        let resource = ImageResource(downloadURL: imageUrl,
                                     cacheKey: viewModel.dishes[indexPath.row].image)
        self.dishImage.kf.setImage(with: resource, placeholder: UIImage(named: "DishPlaceHolder"))
    }
    
    func configureForHistoryScreen(with viewModel: HistoryViewModel, for indexPath: IndexPath) {
        self.nameLabel.text = viewModel.dishes[indexPath.row].name
        self.timeLabel.text = viewModel.dishes[indexPath.row].cookTime
        self.ratingView.rating = viewModel.dishes[indexPath.row].rating
        guard let imageUrl = URL(string: viewModel.dishes[indexPath.row].image) else { return }
        let resource = ImageResource(downloadURL: imageUrl,
                                     cacheKey: viewModel.dishes[indexPath.row].image)
        self.dishImage.kf.setImage(with: resource, placeholder: UIImage(named: "DishPlaceHolder"))
    }
    
    func configure(with dish: MenuModel) {
        self.nameLabel.text = dish.name
        self.timeLabel.text = dish.cookTime
        self.ratingView.rating = dish.rating
        guard let imageUrl = URL(string: dish.image) else { return }
        let resource = ImageResource(downloadURL: imageUrl,
                                     cacheKey: dish.image)
        self.dishImage.kf.setImage(with: resource, placeholder: UIImage(named: "DishPlaceHolder"))
    }
    
    func configureForYourRecipesScreen(recipe: RecipeCD) {
        self.nameLabel.text = recipe.name
        if let imageData = recipe.image {
            self.dishImage.image = UIImage(data: imageData, scale: 1.0)
        } else {
            self.dishImage.image = UIImage(named: "DishPlaceHolder")
        }
        self.ratingView.isHidden = true
        self.timeLabel.text = recipe.time ?? ""
    }
}
