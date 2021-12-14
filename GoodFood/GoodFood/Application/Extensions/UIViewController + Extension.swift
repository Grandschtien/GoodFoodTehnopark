//
//  UIViewController + Extension.swift
//  GoodFood
//
//  Created by Егор Шкарин on 19.11.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func makeAlert(_ text: String) {
        let alertVC = UIAlertController(title: "Что-то пошло не так...", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
