//
//  SortCell.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import UIKit

class SortCell: UITableViewCell {

    static let reuseId = "SortCell"
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMark.isHidden = true
    }
    
}
