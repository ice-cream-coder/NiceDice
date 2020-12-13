//
//  DiceRole.swift
//  Nice Dice
//
//  Created by Roy Dawson on 1/2/18.
//  Copyright © 2018 Roy Dawson. All rights reserved.
//

import Foundation


struct Roll {
    var die: Int
    var side: Int
    
    init(die: Int) {
        self.die = die
        self.side = Int.random(in: 1...die)
    }
}

struct RollGroup {
    var rolls = [Roll]()
    
    func rollString() -> String {
        var types = [Int:Int]()
        
        for roll in rolls {
            types[roll.die, default: 0] += 1
        }
        
        return types
            .map { die, count in "\(count)d\(die)" }
            .joined(separator: "+")
    }
    
    func totalString() -> String {
        let total = rolls
            .map(\.side)
            .reduce(0, +)
        if total == 0 {
            return "--"
        } else {
            return String(total)
        }
    }
}
