//
//  StageCell.swift
//  GoodFood
//
//  Created by Иван on 25.11.2021.
//

import UIKit
protocol StageCellDelegate: AnyObject {
    func presentAlert(cell: UITableViewCell?)
}

class StageCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var stageTextView: UITextField!
    
    weak var delegate: StageCellDelegate?
    static let reuseId = "StageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        stageTextView.font = .systemFont(ofSize: 17)
        photoImageView.image = UIImage(named: "PhotoPlaceholder")
        photoImageView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(chooseImageOnClick))
        photoImageView.addGestureRecognizer(tapGR)
        photoImageView.contentMode = .scaleAspectFill
    }

    @objc
    private func chooseImageOnClick() {
        delegate?.presentAlert(cell: self)
    }

    
}

extension StageCell: AddViewControllerDelegate {
    func passImage(image: UIImage?) {
        photoImageView.image = image ?? UIImage(named: "PhotoPlaceholder")
    }
}
