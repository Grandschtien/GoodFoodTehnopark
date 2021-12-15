//
//  IngredientCell.swift
//  GoodFood
//
//  Created by Иван on 24.11.2021.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var ingredientTextField: UITextField!
    static let reuseId = "IngredientCell"
    private let dataBaseManager: DataManager = DataManager.shared
//    let obj = RecipeCD()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientTextField.font = .systemFont(ofSize: 17)
        selectionStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name(rawValue: "ConfirmRecipe"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc
    func notificationAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as? [String: RecipeCD] {
            if let recipe = dict["recipe"]{
                dataBaseManager.createIngredient(recipe: recipe) { ingredient in
                    ingredient.name = ingredientTextField.text
                }
            }
        }
    }
}
