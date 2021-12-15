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
        timePicker.datePickerMode = .time
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
    }
}

extension TimeCell: SaveTimeDelegate {
    func saveTime(recipe: RecipeCD) {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: timePicker.date)
        let hour = comp.hour ?? 0
        let minute = comp.minute ?? 0
        if hour == 0 {
            recipe.time = "\(minute) min"
        } else {
            recipe.time = "\(hour) h \(minute) min"
        }
    }
}
