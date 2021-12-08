//
//  PrepareScreenNetworkManager.swift
//  GoodFood
//
//  Created by Егор Шкарин on 08.12.2021.
//

import Foundation

final class PrepareScreenNetworkManager {
    static func fetchDishSteps(key: String,
                               completion: @escaping (Result<PrepareViewModel, Error>) -> ()) {
        AppNetworkManager.fetchDish(key: key){ result in
            switch result {
            case .success(let snapshot):
                if let response = PrepareViewModel(snapshot: snapshot) {
                    completion(.success(response))
                } else {
                    completion(.failure(AppErrors.incorrectData))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
