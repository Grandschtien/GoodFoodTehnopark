//
//  RatingCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import UIKit
import Cosmos
protocol RatingCellProtocol: AnyObject {
    func pushRating(rating: Double)
}
class RatingCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: RatingCellProtocol?
    static let reuseId = "RatingCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        ratingView.contentMode = .scaleAspectFill
        ratingView.didFinishTouchingCosmos = {[weak self] rating in
            self?.delegate?.pushRating(rating: rating)
        }
    }

    func configure(viewModel: PrepareViewModel) {
        
    }
}
