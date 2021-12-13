//
//  LikedNetworkManager.swift
//  GoodFood
//
//  Created by Егор Шкарин on 08.12.2021.
//

import Foundation
import FirebaseDatabase

final class LikedNetworkManager {
    static func fetchDishes(completion: @escaping (Result<LikedViewModel, Error>) -> ()) {
        AppNetworkManager.fetchLikedDishesKeys { result in
            switch result {
            case .success(let keys):
                let queryRef = Database.database().reference().child("dishes")
                queryRef.observeSingleEvent(of: .value) { snapshot in
                    guard let snapshot = snapshot.value as? [String: Any] else {
                        completion(.failure(AppErrors.noInternetConnection))
                        return
                    }
                    var dict = [String: [String: Any]]()
                    for key in keys {
                        guard let value = snapshot[key] as? [String: Any] else { continue }
                        dict[key] = value
                    }
                    if let viewModel = try? LikedViewModel(arrayDict: dict) {
                        completion(.success(viewModel))
                    }
                }
                break
            case .failure(_):
                completion(.failure(AppErrors.clientInGuestMode))
            }
        }
    }
}
