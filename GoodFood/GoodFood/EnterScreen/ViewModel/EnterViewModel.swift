//
//  EnterViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 02.11.2021.
//

import UIKit
import FirebaseAuth

final class EnterViewModel {
    
    func checkLogIn(email: String, password: String, completion: @escaping (String?) -> ()) {
        AuthNetworkManager.logIn(email: email, password: password) { _ , error in
            guard let error = error else {
                completion(nil)
                return
            }
            if let authError = AuthErrorCode(rawValue: error._code) {
                completion(authError.errorMessage)
            }
        }
    }
}

