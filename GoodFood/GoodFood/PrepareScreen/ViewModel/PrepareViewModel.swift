//
//  PrepareViewModel.swift
//  GoodFood
//
//  Created by Егор Шкарин on 22.11.2021.
//

import Foundation

final class PrepareViewModel {
    let steps: Steps
    
    init?(snapshot: Data) {
        guard let steps = parseJson(from: snapshot, to: Steps.self) else { return nil }
        self.steps = steps
    }
    
}
