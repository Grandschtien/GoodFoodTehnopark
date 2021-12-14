//
//  SortViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import Foundation

final class SortViewModel {
    var unSortedDishes: [MenuModel] = []
    var sortedByNameDishesAZ: [MenuModel] = []
    var sortedByNameDishesZA: [MenuModel] = []
    var sortedByRatingDown: [MenuModel] = []
    var sortedBy: Sort?
    enum Sort {
        case ratingDown
        case nameZA
        case nameAZ
    }
    
    func sort(with sort: Sort) {
        switch sort {
        case .ratingDown:
            sortedBy = .ratingDown
            self.sortedByRatingDown = self.unSortedDishes.sorted(by: { firstDish, secondDish in
                return firstDish.rating > secondDish.rating
            })
        case .nameZA:
            sortedBy = .nameZA
            self.sortedByNameDishesZA = self.unSortedDishes.sorted(by: { firstDish, secondDish in
                return firstDish.name > secondDish.name
            })
        case .nameAZ:
            sortedBy = .nameAZ
            self.sortedByNameDishesAZ = self.unSortedDishes.sorted(by: { firstDish, secondDish in
                return firstDish.name < secondDish.name
            })
        }
    }
}
