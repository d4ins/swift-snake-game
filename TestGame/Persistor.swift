//
//  Persistor.swift
//  TestGame
//
//  Created by Andrii Drozdov on 5/8/19.
//  Copyright © 2019 Andrii Drozdov. All rights reserved.
//

import Foundation

class Persistor {
    struct keys {
        static let bestScore = "@bestScore"
    }
    
    let defaults = UserDefaults.standard
    
    public func saveScore(score: Int) -> Void {
        defaults.set(String(score), forKey: keys.bestScore)
    }
    
    public func readScore() -> Int {
        if let score = defaults.string(forKey: keys.bestScore) {
            return Int(score) ?? 0
        } else {
            return 0
        }
    }
}
