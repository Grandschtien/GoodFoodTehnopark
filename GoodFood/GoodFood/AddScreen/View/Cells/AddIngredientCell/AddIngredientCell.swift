//
//  AddIngredientCell.swift
//  GoodFood
//
//  Created by Иван on 25.11.2021.
//

import UIKit
protocol AddIngredientCellDelegate: AnyObject {
    func addIngredient()
}

class AddIngredientCell: UITableViewCell {

    weak var delegate: AddIngredientCellDelegate?
    static let reuseId = "AddIngredientCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addIngredientButton(_ sender: UIButton) {
        delegate?.addIngredient()
    }
}
