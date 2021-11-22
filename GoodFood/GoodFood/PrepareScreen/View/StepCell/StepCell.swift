//
//  StepCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import UIKit

class StepCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var stepLabel: UILabel!
    static let reuseId = "StepCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        stepImage.layer.cornerRadius = 20
        stepImage.backgroundColor = .blue
        stepLabel.text = "Чтобы установить автоматический размер для высоты строки & предполагаемая высота строки, выполните следующие действия, чтобы сделать автоматический размер эффективным для макета высоты ячейки/строки. "
    }
    
    func configure(viewModel: PrepareViewModel) {
        
    }
}
