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
        let predicate = NSPredicate(format: "%K == %@", "recipe", recipe)
        fr.predicate = predicate
        return (try? storeContainer.viewContext.fetch(fr)) ?? []
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
        
        try? storeContainer.viewContext.save()
    }
    
    func createIngredient(recipe: RecipeCD, configBlock: (IngredientCD) -> Void) {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: "IngredientCD",
                                                            into: storeContainer.viewContext) as? IngredientCD else {
            return
        }
        
        configBlock(obj)
        
        try? storeContainer.viewContext.save()
    }
    
    func createStage(recipe: RecipeCD, configBlock: (StageCD) -> Void) {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: "StageCD",
                                                            into: storeContainer.viewContext) as? StageCD else {
            return
        }
        
        configBlock(obj)
        
        try? storeContainer.viewContext.save()
    }
}
