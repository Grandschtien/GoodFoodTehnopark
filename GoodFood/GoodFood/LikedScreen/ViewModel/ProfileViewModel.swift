//
//  ProfileViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.11.2021.
//

import Foundation

class ProfileViewModel {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> ()) {
        AppNetworkManager.fetchProfileData { result in
            switch result {
            case .success(let dictionary):
                guard let profile = Profile(dictionary: dictionary) else {
                    completion(.failure(AppErrors.incorrectProfileData))
                    return
                }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
