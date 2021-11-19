//
//  AppNetworkManager.swift
//  GoodFood
//
//  Created by Егор Шкарин on 18.11.2021.
//

import Foundation
import Firebase

enum AppErrors: Error {
    case clientInGuestMode
    case cannotFetchProfileData
    case incorrectProfileData
}

final class AppNetworkManager {
    
    static func fetchProfileData(completion: @escaping (Result<NSDictionary, Error>) -> ()) {
        if let user = Auth.auth().currentUser {
            let queryRef =  Database.database().reference().child("users")
            let userID = user.uid
            queryRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshot = snapshot.value as? NSDictionary else {
                    completion(.failure(AppErrors.cannotFetchProfileData))
                    return
                }
                completion(.success(snapshot))
            })
        }
        else {
            completion(.failure(AppErrors.clientInGuestMode))
        }
    }
}
