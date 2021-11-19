//
//  UIImage + init?.swift
//  GoodFood
//
//  Created by Егор Шкарин on 19.11.2021.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(data: Data?) {
        guard let data = data else { return nil }
        self.init(data: data)
    }
}
