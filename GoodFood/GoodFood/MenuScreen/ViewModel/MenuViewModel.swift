//
//  MenuViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.11.2021.
//

import Foundation
import Firebase
import UIKit


final class MenuViewModel {
    
    var dishes: [MenuModel]
    
    enum Sort {
        case time
        case rating
        case name
    }
    
    init(snapshots: [DataSnapshot]) throws {
        var dishes = [MenuModel]()
        
        for snapshot in snapshots {
            guard let dict = snapshot.value as? [String: Any],
                  let dish = MenuModel(dict: dict, key: snapshot.key)
            else { throw AppErrors.incorrectData }
            dishes.append(dish)
        }
        self.dishes = dishes
    }
    
    func sort(with sort: Sort) {
        switch sort {
        case .time:
            self.dishes = self.dishes.sorted(by: { firstDish, secondDish in
                return firstDish.cookTime < secondDish.cookTime
            })
        case .rating:
            self.dishes = self.dishes.sorted(by: { firstDish, secondDish in
                return firstDish.rating < secondDish.rating
            })
        case .name:
            self.dishes = self.dishes.sorted(by: { firstDish, secondDish in
                return firstDish.name < secondDish.name
            })
        }
    }
    
    
}
