//
//  Steps.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import Foundation

struct Steps: Codable {
    let steps: [String]
    
    enum CodingKeys: String, CodingKey {
        case steps = "Steps"
    }
}
