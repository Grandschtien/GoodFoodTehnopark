//
//  AppNetworkManager.swift
//  GoodFood
//
//  Created by Егор Шкарин on 18.11.2021.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit
import AVFoundation

enum AppErrors: Error {
    case clientInGuestMode
    case cannotFetchProfileData
    case incorrectData
    case cannotCastToDictionary
    case invalidUrl
    case noInternetConnection
    case noLikedRecipes
}

final class AppNetworkManager {
    
    static func fetchProfileData(completion: @escaping (Result<[String: Any], Error>) -> ()) {
        if let user = Auth.auth().currentUser {
            let queryRef =  Database.database().reference().child("users")
            let userID = user.uid
            queryRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                guard var snapshot = snapshot.value as? [String: Any] else {
                    completion(.failure(AppErrors.incorrectData))
                    return
                }
                if let imageUrl = snapshot["avatar"] as? String {
                    let imageRef = Storage.storage().reference(forURL: imageUrl)
                    let megaByte = Int64(1 * 1024 * 1024)
                    imageRef.getData(maxSize: megaByte) { (data, error) in
                        guard let imageData = data else { return }
                        snapshot.updateValue(imageData, forKey: "avatar")
                        completion(.success(snapshot))
                    }
                }
                completion(.success(snapshot))
            })
        }
        else {
            completion(.failure(AppErrors.clientInGuestMode))
        }
    }
    
    static func uploadProfileImage(currentUserId: String, imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child("avatars").child(currentUserId)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
        
    }
    static func uploadKeyOfLikedDish(key: String) {
        if let currentUser = Auth.auth().currentUser {
            let queryRef = Database
                .database()
                .reference()
                .child("users")
                .child(currentUser.uid)
                .child("LikedDishes")
                .child(key)
            queryRef.setValue("dish\(key)")
        }
        UserDefaults.standard.set(true, forKey: key)
    }
    
    static func deleteKeyOfLikedImage(key: String) {
        if let currentUser = Auth.auth().currentUser {
            let queryRef = Database
                .database()
                .reference()
                .child("users")
                .child(currentUser.uid)
                .child("LikedDishes")
                .child(key)
            queryRef.setValue(nil)
            UserDefaults.standard.set(false, forKey: key)
        }
    }
    static func fetchDishesData(completion: @escaping (Result<[DataSnapshot], Error>) -> ()) {
        let queryRef = Database.database().reference().child("dishes")
        queryRef.observeSingleEvent(of: .value) { snapshot in
            guard let objects = snapshot.children.allObjects as? [DataSnapshot]
            else {
                completion(.failure(AppErrors.incorrectData))
                return
            }
            completion(.success(objects))
        }
    }
    
    static func fetchLikedDishesKeys(completion: @escaping (Result<[String], Error>) -> ()) {
        if let user = Auth.auth().currentUser {
            let queryRef =  Database.database().reference().child("users").child(user.uid).child("LikedDishes")
            
            queryRef.observeSingleEvent(of: .value) { snapshot in
                var keysArray = [String]()
                guard let snapshot = snapshot.value as? [String: Any]
                else {
                    completion(.failure(AppErrors.incorrectData))
                    return
                }
                for key in snapshot.keys {
                    keysArray.append(String(key))
                }
                completion(.success(keysArray))
            }
        } else {
            completion(.failure(AppErrors.clientInGuestMode))
        }
    }
    
    static func fetchDish(key: String, completion: @escaping (Result<Data, Error>) -> ()) {
        let queryRef = Database.database().reference().child("dishes").child(key)
        queryRef.observeSingleEvent(of: .value) { snapshot in
            guard let snapshot = snapshot.data else {
                completion(.failure(AppErrors.incorrectData))
                return
            }
            completion(.success(snapshot))
        }
    }
    static func clearUserDefaults() {
        if let user = Auth.auth().currentUser {
            let allLikedDishes = Database.database().reference().child("users").child(user.uid).child("LikedDishes")
            allLikedDishes.observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else { return }
                DispatchQueue.main.async {
                    for key in dict.keys {
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                }
            }
        }
    }
    static func setupUserDefaults() {
        if let user = Auth.auth().currentUser {
            let allLikedDishes = Database.database().reference().child("users").child(user.uid).child("LikedDishes")
            allLikedDishes.observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else { return }
                DispatchQueue.main.async {
                    for key in dict.keys {
                        UserDefaults.standard.set(true, forKey: key)
                    }
                }
            }
        }
    }
    
    static func checkUser() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        else {
            return false
        }
    }
    
    static func getOldRating(dishForKey key: String, completion: @escaping (Double, Int?) -> ()) {
        let queryRef = Database.database().reference().child("dishes").child(key)
        
        queryRef.observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            completion(dict["Rating"] as? Double ?? 0, dict["CountOfRatings"] as? Int)
        }

    }
}

extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}
extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
}

