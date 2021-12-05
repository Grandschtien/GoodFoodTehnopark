//
//  ProfileViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.11.2021.
//

import Foundation
import UIKit
import Firebase

class ProfileViewModel {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> ()) {
        AppNetworkManager.fetchProfileData { result in
            switch result {
            case .success(let dictionary):
                guard let profile = Profile(dictionary: dictionary) else {
                    completion(.failure(AppErrors.incorrectData))
                    return
                }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func uploadProfileImage(image: UIImage) {
        if let user = Auth.auth().currentUser {
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            AppNetworkManager.uploadProfileImage(currentUserId: user.uid, imageData: imageData) { result in
                switch result {
                case .success(let url):
                    let ref = Database.database().reference().child("users")
                    ref.child(user.uid).updateChildValues(["avatar": url.absoluteString])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
//    func removeUserInfo() {
//        if UserDefaults.standard.value(forKey: UserDefaultsManager.UserInfo.email.rawValue) != nil,
//           UserDefaults.standard.value(forKey: UserDefaultsManager.UserInfo.name.rawValue) != nil {
//            UserDefaultsManager.removeUserInfo()
//        }
//    }
    
}
