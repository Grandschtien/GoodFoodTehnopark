//
//  ProfileModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 11.11.2021.
//

import Foundation

struct Profile {
    let name: String
    let email: String
    let image: Data?
    
    init?(dictionary: NSDictionary) {
        guard let name = dictionary["name"] as? String, let email = dictionary["email"] as? String else { return nil }
        self.name = name
        self.email = email
        self.image = dictionary["image"] as? Data
    }
}
