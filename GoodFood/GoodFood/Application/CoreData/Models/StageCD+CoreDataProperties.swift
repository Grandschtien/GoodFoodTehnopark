//
//  StageCD+CoreDataProperties.swift
//  GoodFood
//
//  Created by Иван on 15.12.2021.
//
//

import Foundation
import CoreData


extension StageCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StageCD> {
        return NSFetchRequest<StageCD>(entityName: "StageCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipe: RecipeCD?

}

extension StageCD : Identifiable {

}
