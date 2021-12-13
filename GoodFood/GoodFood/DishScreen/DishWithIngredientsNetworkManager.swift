//
//  DishWithIngredientsNetworkManager.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.12.2021.
//

import Foundation

final class DishWithIngredientsNetworkManager {
    static func fetchDishWithIngredients(key: String, completion: @escaping (Result<DishViewModel, Error>) -> ()) {
        AppNetworkManager.fetchDish(key: key){ result in
            switch result {
            case .success(let snapshot):
                if let response = DishViewModel(snapshot: snapshot) {
                    completion(.success(response))
                } else {
                    completion(.failure(AppErrors.incorrectData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
