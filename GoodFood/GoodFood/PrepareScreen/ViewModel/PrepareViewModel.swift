//
//  PrepareViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import Foundation
import Firebase

final class PrepareViewModel {
    let steps: Steps
    
    init?(snapshot: Data) {
        guard let steps = parseJson(from: snapshot, to: Steps.self) else { return nil }
        self.steps = steps
    }
    
    func updateRating(dishForkey key: String, rating: Double) {
        AppNetworkManager.getOldRating(dishForKey: key) { oldRating, count in
            var newRating: Double = 0
            if let count = count {
                newRating = (rating + oldRating) / Double(count)
                let queryRef = Database.database().reference().child("dishes").child(key)
                queryRef.updateChildValues(["Rating": newRating])
                queryRef.updateChildValues(["CountOfRatings": count + 1])
            } else {
                let count = 2
                newRating = (rating + oldRating) / Double(count)
                let queryRef = Database.database().reference().child("dishes").child(key)
                queryRef.updateChildValues(["Rating": newRating])
                queryRef.updateChildValues(["CountOfRatings": count])
            }
        }
    }
    func uploadFinishingRecipe(key: String) {
        AppNetworkManager.uploadKeyOfFinishedDish(key: key)
    }
}
