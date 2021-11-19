//
//  AuthNetworkManager.swift
//  GoodFood
//
//  Created by Егор Шкарин on 18.11.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit

final class AuthNetworkManager {
    
    static func logIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            completion(authDataResult, error)
        }
    }
    
    static func register(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            completion(authDataResult, error)
        }
    }
    
    static func restorePassword(email: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
        
    }
}


