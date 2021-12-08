//
//  MenuNetworkService.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.12.2021.
//

import Foundation
import Firebase


final class MenuNetworkService {
    static func fetchDishes(completion: @escaping (Result<MenuViewModel, Error>) -> ()) {
        AppNetworkManager.fetchDishesData { result in
            switch result {
            case .success(let snapshots):
                if let response = try? MenuViewModel(snapshots: snapshots) {
                    completion(.success(response))
                } else {
                    completion(.failure(AppErrors.incorrectData))
                }
            case .failure(_):
                completion(.failure(AppErrors.noInternetConnection))
            }
        }
    }
}
