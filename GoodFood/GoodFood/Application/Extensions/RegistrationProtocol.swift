//
//  RegistrationProtocol.swift
//  GoodFood
//
//  Created by Егор Шкарин on 30.10.2021.
//

import Foundation
import UIKit
///Протокол с дефолтными функциями для верстки полей, теков и тд в регистрации.
protocol RegistrationProtocol {
    func setupTF(_ tf: UITextField, superView: UIView)
    func setupTextLabels(_ label: UILabel, text: String)
    func setupStackViews(_ stack: UIStackView, spacing: CGFloat, aligment: UIStackView.Alignment)
    func setupMainLabel(_ label: UILabel, text: String)
}

extension RegistrationProtocol {
    /// Настройка текстовых полей
    func setupTF(_ tf: UITextField, superView: UIView) {
        tf.font = UIFont(name: "system", size: 17)
        tf.font = tf.font?.withSize(17)
        tf.setUnderLine(superView: superView)
    }
    /// Настройка лейблов над тектовым полем
    func setupTextLabels(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: "system", size: 15)
        label.font = label.font.withSize(15)
        label.textColor = UIColor(named: "LaunchScreenLabelColor")
    }
    /// Настройка стеков
    func setupStackViews(_ stack: UIStackView, spacing: CGFloat, aligment: UIStackView.Alignment) {
        stack.axis = .vertical
        stack.spacing = spacing
        stack.distribution = .fill
        stack.contentMode = .scaleToFill
        stack.alignment = aligment
    }
    /// Настройка заглавных лейблов в регистрации
    func setupMainLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = label.font.withSize(30)
        label.sizeToFit()
    }
}
