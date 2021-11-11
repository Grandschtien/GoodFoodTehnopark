//
//  MenuCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 31.10.2021.
//

import UIKit
import Cosmos

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
        self.timeLabel.textColor = UIColor(named: "LaunchScreenLabelColor")
    }
    
    func configure() {
        
    }
}
