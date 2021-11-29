//
//  CALayer+Extension.swift
//  GoodFood
//
//  Created by Егор Шкарин on 27.10.2021.
//

import Foundation
import UIKit

extension UITextField {
    func setUnderLine(superView view: UIView) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height + 20, width: view.frame.width - 60, height: 1.0)
        bottomLine.backgroundColor = UIColor(named: "LaunchScreenLabelColor")?.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
        self.layer.masksToBounds = true
    }
}
