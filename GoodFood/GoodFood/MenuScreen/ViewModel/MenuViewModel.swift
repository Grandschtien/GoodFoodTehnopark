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
    
    init(snapshots: [DataSnapshot]) throws {
        var dishes = [MenuModel]()
        
        for snapshot in snapshots {
            guard let dict = snapshot.value as? [String: Any],
                  let dish = MenuModel(dict: dict)
            else { continue }
            dishes.append(dish)
        }
        self.dishes = dishes
    }
    
}
