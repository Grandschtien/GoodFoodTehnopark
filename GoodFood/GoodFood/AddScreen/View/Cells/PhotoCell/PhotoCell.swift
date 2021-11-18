//
//  PhotoCell.swift
//  GoodFood
//
//  Created by Иван on 18.11.2021.
//

import UIKit
protocol PhotoCellDelegate: AnyObject {
    func presentAlert()
}

class PhotoCell: UITableViewCell
//, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    
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
        photoImageView.isUserInteractionEnabled = true
        photoImageView.contentMode = .scaleAspectFill
        //        self.addSubview(alertView)
    }
    
        @objc
        private func chooseImageOnClick() {
            delegate?.presentAlert()
        }
    
    
    
}

//MARK: - UIImagePickerControllerDelegate
//extension PhotoCell:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        /*
//         Get the image from the info dictionary.
//         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
//         instead of `UIImagePickerControllerEditedImage`
//         */
//        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
//            self.imgProfile.image = editedImage
//        }
//
//        //Dismiss the UIImagePicker after selection
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.isNavigationBarHidden = false
//        self.dismiss(animated: true, completion: nil)
//    }
//}

extension PhotoCell: AddViewControllerDelegate {
    func passImage(image: UIImage?) {
        photoImageView.image = image ?? UIImage(named: "PhotoPlaceholder")
    }
    
    
}
