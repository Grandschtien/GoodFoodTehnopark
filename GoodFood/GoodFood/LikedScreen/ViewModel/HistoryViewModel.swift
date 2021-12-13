//
//  HistoryViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 12.11.2021.
//

import Foundation

final class HistoryViewModel {
    var dishes: [MenuModel]
    
    init(arrayDict: [String: [String: Any]]) throws {
        var dishes = [MenuModel]()
        for key in arrayDict.keys {
            guard let value = arrayDict[key],
                  let dish = MenuModel(dict: value, key: key)
            else { throw AppErrors.incorrectData }
            dishes.append(dish)
        }
        self.dishes = dishes
    }
}
