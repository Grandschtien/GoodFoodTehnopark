//
//  NameCell.swift
//  GoodFood
//
//  Created by Иван on 15.11.2021.
//

import UIKit

class NameCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    static let reuseId = "NameCell"
    
//    init(text: String) {
//        nameTextField.text = text
//        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: NameCell.reuseId)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        nameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: contentView.frame.width - 32, height: contentView.frame.height - 10))
//        nameTextField.setUnderLine(superView: self)
        
//        nameTextField.setUnderLine(superView: nameTextField)
//        self.containerView.layer.masksToBounds = true
//        nameTextField.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}