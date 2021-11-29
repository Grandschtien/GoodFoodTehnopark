//
//  Dish.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import Foundation

// MARK: - DishElement
struct Dish: Codable {
    let name: String?
    let image: String?
    let cookTime: String?
    let steps: [String]?
    let ingredients: [Ingredient]?
    let categories: [String]?
    let content: Content?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case image = "Image"
        case cookTime = "Cook time"
        case steps = "Steps"
        case ingredients = "Ingredients"
        case categories = "Categories"
        case content = "Content"
    }
    
//    init?(dictionary: [String: Any]) {
//        guard let name = dictionary[CodingKeys.name.rawValue] as? String,
//              let image = dictionary[CodingKeys.image.rawValue] as? Data,
//              let cookTime = dictionary[CodingKeys.cookTime.rawValue] as? String,
//              let steps = dictionary[CodingKeys.steps.rawValue] as? [String],
//              let ingredients = dictionary[CodingKeys.ingredients.rawValue] as? [Ingredient],
//              let catigories = dictionary[CodingKeys.categories.rawValue]as? [String],
//              let content = dictionary[CodingKeys.content.rawValue] as? Content
//        else {
//            return nil
//        }
//        self.name = name
//        self.image = image
//        self.cookTime = cookTime
//        self.steps = steps
//        self.ingredients = ingredients
//        self.categories = catigories
//        self.content = content
//        
//              
//    }
}

// MARK: - Content
struct Content: Codable {
    let calories, protein, fat, carbohydrate: String

    enum CodingKeys: String, CodingKey {
        case calories = "Calories"
        case protein = "Protein"
        case fat = "Fat"
        case carbohydrate = "Carbohydrate"
    }
}


