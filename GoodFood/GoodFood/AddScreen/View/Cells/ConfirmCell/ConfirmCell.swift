//
//  ConfirmCell.swift
//  GoodFood
//
//  Created by Иван on 18.11.2021.
//

import UIKit
protocol ConfirmCellDelegate: AnyObject {
    func confirmRecipe()
}

class ConfirmCell: UITableViewCell {

    @IBOutlet weak var confirmRecipeButton: UIButton!
    
    static let reuseId = "ConfirmCell"
    weak var delegate: ConfirmCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        confirmRecipeButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        delegate?.confirmRecipe()
    }
    
    
}
