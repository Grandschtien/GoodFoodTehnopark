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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientTextField.font = .systemFont(ofSize: 17)
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
