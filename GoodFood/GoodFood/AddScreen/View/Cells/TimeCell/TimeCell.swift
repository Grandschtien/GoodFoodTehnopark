//
//  TimeCell.swift
//  GoodFood
//
//  Created by Иван on 18.11.2021.
//

import UIKit

class TimeCell: UITableViewCell {

    @IBOutlet weak var timePicker: UIPickerView!
    
    let namesOfComponents = ["ч", "       мин"]
    
    static let reuseId = "TimeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timePicker.dataSource = self
        timePicker.delegate = self
        
        let labelWidth = timePicker.frame.width / CGFloat(timePicker.numberOfComponents)

            for index in 0..<namesOfComponents.count {
                let label = UILabel(frame: CGRect(x: timePicker.frame.origin.x + labelWidth * CGFloat(index + 1) - 20, y: timePicker.frame.origin.y + timePicker.frame.height/2 + 20, width: 80, height: 20))
                label.text = namesOfComponents[index]
                label.textAlignment = .left
//                label.backgroundColor = .cyan
                timePicker.addSubview(label)
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TimeCell: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        default:
            break
        }
        return 0
    }
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
}

extension TimeCell: UIPickerViewDelegate {
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
}
