//
//  AppNetworkManager.swift
//  GoodFood
//
//  Created by Егор Шкарин on 18.11.2021.
//

import Foundation
import Firebase
import FirebaseStorage

enum AppErrors: Error {
    case clientInGuestMode
    case cannotFetchProfileData
    case incorrectProfileData
}

final class AppNetworkManager {
    
    static func fetchProfileData(completion: @escaping (Result<[String: Any], Error>) -> ()) {
        if let user = Auth.auth().currentUser {
            let queryRef =  Database.database().reference().child("users")
            let userID = user.uid
            queryRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                guard var snapshot = snapshot.value as? [String: Any] else {
                    completion(.failure(AppErrors.cannotFetchProfileData))
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
}
