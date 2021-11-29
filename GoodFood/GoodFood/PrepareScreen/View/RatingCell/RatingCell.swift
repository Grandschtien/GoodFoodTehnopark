//
//  RatingCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import UIKit
import Cosmos
class RatingCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var label: UILabel!
    
    static let reuseId = "RatingCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        ratingView.contentMode = .scaleAspectFill
    }

    func configure(viewModel: PrepareViewModel) {
        
    }
}
