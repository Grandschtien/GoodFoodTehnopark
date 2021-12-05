//
//  TimeCell.swift
//  GoodFood
//
//  Created by Иван on 18.11.2021.
//

import UIKit

class TimeCell: UITableViewCell {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    static let reuseId = "TimeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timePicker.datePickerMode = .countDownTimer
    }
    
}
