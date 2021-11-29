//
//  MenuViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 07.11.2021.
//

import Foundation
import Firebase


final class MenuViewModel {
    
    var dishes: [MenuModel]?
    
    func fetchDishes(completion: @escaping (Error?) -> ()) {
        AppNetworkManager.fetchDishesData { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let decodedDishes = self?.parseJson(from: data, to: [Dish].self) else {
                    return
                }
                for dish in decodedDishes {
                    print(dish.image ?? "")
                    AppNetworkManager.fetchDishesImageData(url: dish.image ?? "") {[weak self] image in
                        if let image = image, let name = dish.name, let cookTime = dish.cookTime {
                            
                            DispatchQueue.main.async {
                                let dishInMenu = MenuModel(name: name,
                                                           cookTime: cookTime,
                                                           image: image,
                                                           rating: 5)
                                self?.dishes?.append(dishInMenu)
                                print(dishInMenu)
                                
                            }
                        }
                    }
                }
                
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    func compareDishes(dishes: [MenuModel], imagesUrl: [Data]) {
        
    }
    private func parseJson<T: Decodable>(from data: Data, to type: T.Type) -> T?{
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(type, from: data)
        return decoded
    }
}
