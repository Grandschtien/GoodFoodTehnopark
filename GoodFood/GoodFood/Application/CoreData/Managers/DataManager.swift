//
//  DataManager.swift
//  GoodFood
//
//  Created by Иван on 15.12.2021.
//

import Foundation
import CoreData

final class DataManager {
    private let modelName = "GoodFood"
    
    static let shared = DataManager()
    
    private let storeContainer: NSPersistentContainer
    
    private init() {
        self.storeContainer = NSPersistentContainer(name: modelName)
    }
    
    func initCoreData(completion: @escaping () -> Void) {
        storeContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            completion()
        }
    }
    
    func fetch() -> [RecipeCD] {
        return (try? storeContainer.viewContext.fetch(RecipeCD.fetchRequest())) ?? []
    }
    
    func fetchIngredients() -> [IngredientCD] {
        return (try? storeContainer.viewContext.fetch(IngredientCD.fetchRequest())) ?? []
    }
    
    func fetchIngredientsForRecipe(recipe: RecipeCD) -> [IngredientCD] {
        let fr = IngredientCD.fetchRequest()
        let predicate = NSPredicate(format: "recipe == %@", recipe)
        fr.predicate = predicate
        do {
            let result = try storeContainer.viewContext.fetch(fr)
            return result
        } catch let error {
            print(error)
            return []
        }
    }
    
    func fetchStages() -> [StageCD] {
        return (try? storeContainer.viewContext.fetch(StageCD.fetchRequest())) ?? []
    }
    
    func fetchStagesForRecipe(recipe: RecipeCD) -> [StageCD] {
        let fr = StageCD.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", "recipe", recipe)
        fr.predicate = predicate
        return (try? storeContainer.viewContext.fetch(fr)) ?? []
    }
    
    func createRecipe(configBlock: (RecipeCD) -> Void) {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: "RecipeCD",
                                                            into: storeContainer.viewContext) as? RecipeCD else {
            return
        }
        
        configBlock(obj)
        
        save()
//        try! storeContainer.viewContext.save()
    }
    
    func createIngredient(recipe: RecipeCD, configBlock: (IngredientCD) -> Void) {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: "IngredientCD",
                                                            into: storeContainer.viewContext) as? IngredientCD else {
            return
        }
        obj.recipe = recipe
        
        configBlock(obj)
        
        save()
//        try? storeContainer.viewContext.save()
    }
    
    func createStage(recipe: RecipeCD, configBlock: (StageCD) -> Void) {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: "StageCD",
                                                            into: storeContainer.viewContext) as? StageCD else {
            return
        }
        obj.recipe = recipe
        
        configBlock(obj)
        
        save()
//        try? storeContainer.viewContext.save()
    }
    
    func save() {
        do {
            try storeContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}
