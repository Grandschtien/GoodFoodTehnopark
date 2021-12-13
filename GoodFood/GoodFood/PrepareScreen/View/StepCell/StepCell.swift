//
//  StepCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import UIKit

class StepCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stepLabel: UILabel!
    static let reuseId = "StepCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
    }
    
    func configure(viewModel: PrepareViewModel, indexPath: IndexPath) {
        stepLabel.text = viewModel.steps.steps[indexPath.row]
    }
}
