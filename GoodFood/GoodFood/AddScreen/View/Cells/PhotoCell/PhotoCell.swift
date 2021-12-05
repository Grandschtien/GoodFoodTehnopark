//
//  PhotoCell.swift
//  GoodFood
//
//  Created by Иван on 18.11.2021.
//

import UIKit
protocol PhotoCellDelegate: AnyObject {
    func presentAlert(cell: UITableViewCell?)
}

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    weak var delegate: PhotoCellDelegate?
    static let reuseId = "PhotoCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
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

extension PhotoCell: AddViewControllerDelegate {
    func passImage(image: UIImage?) {
        photoImageView.image = image ?? UIImage(named: "PhotoPlaceholder")
    }
}
