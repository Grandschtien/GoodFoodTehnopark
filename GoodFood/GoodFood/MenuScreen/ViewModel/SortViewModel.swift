//
//  SortViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import Foundation

final class SortViewModel {
    var unSortedDishes: [MenuModel] = []
    var sortedByNameDishes: [MenuModel] = []
    var sortedByRatingUp: [MenuModel] = []
    var sortedByRatingDown: [MenuModel] = []
    var sortedBy: Sort?
    enum Sort {
        case ratingDown
        case ratingUp
        case name
    }
    
    func sort(with sort: Sort) {
        switch sort {
        case .ratingUp:
            sortedBy = .ratingUp
            self.sortedByRatingUp = self.unSortedDishes.sorted(by: { firstDish, secondDish in
                return firstDish.rating < secondDish.rating
            })
        case .ratingDown:
            sortedBy = .ratingDown
            self.sortedByRatingDown = self.unSortedDishes.sorted(by: { firstDish, secondDish in
                return firstDish.rating > secondDish.rating
            })
        case .name:
            sortedBy = .name
            self.sortedByNameDishes = self.unSortedDishes.sorted(by: { firstDish, secondDish in
                return firstDish.name < secondDish.name
            })
        }
    }
}
