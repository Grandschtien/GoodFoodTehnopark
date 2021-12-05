//
//  AddStageCell.swift
//  GoodFood
//
//  Created by Иван on 26.11.2021.
//

import UIKit
protocol AddStageCellDelegate: AnyObject {
    func addStage()
}

class AddStageCell: UITableViewCell {
    
    weak var delegate: AddStageCellDelegate?
    static let reuseId = "AddStageCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addStageButton(_ sender: UIButton) {
        delegate?.addStage()
    }
}
