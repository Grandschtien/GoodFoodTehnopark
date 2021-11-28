//
//  HelperButton.swift
//  GoodFood
//
//  Created by Егор Шкарин on 19.11.2021.
//

import UIKit

class HelperButton: UIButton {
    private var color: UIColor = .black
    private let titleColor = UIColor(named: "LaunchScreenLabelColor")
    private let fontSize: CGFloat = 15
    private let touchDownAlpha: CGFloat = 0.1
    private weak var timer: Timer?
    private let timerStep: TimeInterval = 0.01
    private let animateTime: TimeInterval = 0.4
    private lazy var alphaStep: CGFloat = {
        return (1 - touchDownAlpha) / CGFloat(animateTime / timerStep)
    }()
    func setup() {
        backgroundColor = .clear
        layer.backgroundColor = color.cgColor
        
        titleLabel?.font = titleLabel?.font.withSize(fontSize)
        setTitleColor(titleColor, for: .normal)
        
        clipsToBounds = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let backgroundColor = backgroundColor {
            color = backgroundColor
        }
        
        setup()
    }
    
    convenience init(color: UIColor? = nil, title: String? = nil, aligment: UIControl.ContentHorizontalAlignment = .center) {
        self.init(type: .custom)
        
        if let color = color {
            self.color = color
        }
        
        if let title = title {
            setTitle(title, for: .normal)
        }
        
        contentHorizontalAlignment = aligment
        setup()
    }
    
    deinit {
        stopTimer()
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                cancelTracking(with: nil)
                touchUp()
            }
        }
    }
    
    func touchDown() {
        stopTimer()
        setTitleColor(color.withAlphaComponent(touchDownAlpha), for: .normal)
    }
    
    func touchUp() {
        timer = Timer.scheduledTimer(timeInterval: timerStep,
                                     target: self,
                                     selector: #selector(animation),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    
    @objc
    func animation() {
        guard let backgroundAlpha = layer.backgroundColor?.alpha else {
            stopTimer()
            return
        }
        
        let newAlpha = backgroundAlpha + alphaStep
        
        if newAlpha < 1 {
            setTitleColor(color.withAlphaComponent(newAlpha), for: .normal)
        } else {
            setTitleColor(titleColor, for: .normal)
            stopTimer()
        }
    }
    
}
