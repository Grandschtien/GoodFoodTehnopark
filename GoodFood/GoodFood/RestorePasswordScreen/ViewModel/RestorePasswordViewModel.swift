//
//  RestorePasswordViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.11.2021.
//

import Foundation
import FirebaseAuth

final class RestorePasswordViewModel {
    
    func restore(email: String, completion: @escaping (String?) -> ()) {
        AuthNetworkManager.restorePassword(email: email) { error in
            if error == nil {
                completion(nil)
            } else {
                if let authError = AuthErrorCode(rawValue: error!._code) {
                    completion(authError.errorMessage)
                }
            }
        }
    }
}
