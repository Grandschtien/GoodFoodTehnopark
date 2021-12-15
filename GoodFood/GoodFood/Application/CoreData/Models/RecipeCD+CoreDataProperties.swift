//
//  RecipeCD+CoreDataProperties.swift
//  GoodFood
//
//  Created by Иван on 15.12.2021.
//
//

import Foundation
import CoreData


extension RecipeCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeCD> {
        return NSFetchRequest<RecipeCD>(entityName: "RecipeCD")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var time: String?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var stages: NSSet?

}

// MARK: Generated accessors for ingredients
extension RecipeCD {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: IngredientCD)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: IngredientCD)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for stages
extension RecipeCD {

    @objc(addStagesObject:)
    @NSManaged public func addToStages(_ value: StageCD)

    @objc(removeStagesObject:)
    @NSManaged public func removeFromStages(_ value: StageCD)

    @objc(addStages:)
    @NSManaged public func addToStages(_ values: NSSet)

    @objc(removeStages:)
    @NSManaged public func removeFromStages(_ values: NSSet)

}

extension RecipeCD : Identifiable {

}
