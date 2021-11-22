//
//  ParalaxTableView.swift
//  GoodFood
//
//  Created by Егор Шкарин on 21.11.2021.
//

import UIKit

class ParalaxTableView: UITableView {
    
    var heightConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let header = tableHeaderView else { return }
        
        let offsetY = -contentOffset.y
        
        if heightConstraint == nil {
            if let imageView = header.subviews.first as? UIImageView {
                heightConstraint = imageView.constraints.filter{
                    $0.identifier == "imageHeightConstraint"
                }.first
                bottomConstraint = header.constraints.filter{
                    $0.identifier == "imageBottomConstraint"
                }.first
            }
        }
        
        heightConstraint?.constant = max(header.bounds.height, header.bounds.height + offsetY)
        bottomConstraint?.constant = offsetY >= 0 ? 0 : offsetY / 2
        
        header.clipsToBounds = offsetY <= 0
    }
}
