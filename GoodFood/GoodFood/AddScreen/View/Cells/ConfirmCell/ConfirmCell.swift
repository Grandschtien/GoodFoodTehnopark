//
//  ConfirmCell.swift
//  GoodFood
//
//  Created by Иван on 18.11.2021.
//

import UIKit

class ConfirmCell: UITableViewCell {

    @IBOutlet weak var confirmRecipeButton: UIButton!
    
    static let reuseId = "ConfirmCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        confirmRecipeButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
