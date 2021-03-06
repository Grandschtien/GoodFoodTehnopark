//
//  DishViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import Foundation
import Firebase

final class DishViewModel {
    let dish: DishWithIngredient
    init?(snapshot: Data) {
        guard let dish = parseJson(from: snapshot, to: DishWithIngredient.self) else { return nil }
        self.dish = dish
    }
    
    func uploadLikedDish(key: String) {
        AppNetworkManager.uploadKeyOfLikedDish(key: key)
    }
    
    func deletLikedImage(key: String) {
        AppNetworkManager.deleteKeyOfLikedImage(key: key)
    }
    
    func checkLikeFunctional() -> Bool {
        return AppNetworkManager.checkUser()
    }
    
}
func parseJson<T: Decodable>(from data: Data, to type: T.Type) -> T?{
    let decoder = JSONDecoder()
    let decoded = try! decoder.decode(type, from: data)
    return decoded
}

