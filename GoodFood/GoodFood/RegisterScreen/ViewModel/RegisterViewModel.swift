//
//  RegisterViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.11.2021.
//

import Foundation
import Firebase

final class RegisterViewModel {
    
    func registration(name: String, email: String, password: String, completion: @escaping (String?) -> ()) {
        AuthNetworkManager.register(email: email, password: password) { (result, error) in
            guard let error = error else {
                if let result = result {
                    let ref = Database.database().reference().child("users")
                    ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                }
                completion(nil)
                return
            }
            if let authError = AuthErrorCode(rawValue: error._code) {
                completion(authError.errorMessage)
            }
        }
    }
    
}



