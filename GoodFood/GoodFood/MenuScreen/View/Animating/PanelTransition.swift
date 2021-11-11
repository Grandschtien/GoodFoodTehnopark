//
//  PanelTransition.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import Foundation
import UIKit

class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}
