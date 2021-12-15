//
//  NameCell.swift
//  GoodFood
//
//  Created by Иван on 15.11.2021.
//

import UIKit

class NameCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    static let reuseId = "NameCell"
    private let dataBaseManager: DataManager = DataManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.font = .systemFont(ofSize: 17)
        selectionStyle = .none
    }
}

extension NameCell: SaveNameDelegate {
    func saveName(recipe: RecipeCD) {
        recipe.name = nameTextField.text
    }
}
