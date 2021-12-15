//
//  IngredientCD+CoreDataProperties.swift
//  GoodFood
//
//  Created by Иван on 15.12.2021.
//
//

import Foundation
import CoreData


extension IngredientCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientCD> {
        return NSFetchRequest<IngredientCD>(entityName: "IngredientCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipe: RecipeCD?

}

extension IngredientCD : Identifiable {

}
