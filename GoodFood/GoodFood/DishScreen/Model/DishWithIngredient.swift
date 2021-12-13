//
//  DishWithIngredient.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import Foundation

struct DishWithIngredient: Codable {
    let imageString: String
    let name: String
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case imageString = "Image"
        case ingredients = "Ingredients"
    }
}

struct Ingredient: Codable {
    let name, amount: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case amount = "Amount"
    }
}

