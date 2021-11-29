//
//  Dish.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import Foundation

struct Ingredient: Codable {
    let name, amount: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case amount = "Amount"
    }
}

