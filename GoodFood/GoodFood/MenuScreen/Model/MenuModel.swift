//
//  MenuModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 26.11.2021.
//

import Foundation


struct MenuModel {
    let name: String
    let cookTime: String
    let image: String
    let rating: Double
    
    init?(dict: [String: Any]) {
        guard let name = dict["Name"] as? String,
              let cookingTime = dict["Cook time"] as? String,
              let image = dict["Image"] as? String,
              let rating = dict["Rating"] as? Double
        else {
            return nil
        }
        
        self.name = name
        self.cookTime = cookingTime
        self.image = image
        self.rating = rating
    }
}
