//
//  DiceRole.swift
//  Nice Dice
//
//  Created by Roy Dawson on 1/2/18.
//  Copyright © 2018 Roy Dawson. All rights reserved.
//

import Foundation

extension RollGroup {
    func rollString() -> String {
        guard let rolls = rolls else { return "" }

        var types = [Int16:Int]()

        for case let roll as Roll in rolls {
            types[roll.die, default: 0] += 1
        }

        return types
            .map { die, count in "\(count)d\(die)" }
            .joined(separator: "+")
    }
    
    func totalString() -> String {
        guard let rolls = rolls else { return "--" }
        let total = rolls
            .map { $0 as! Roll }
            .map(\.side)
            .reduce(0, +)
        if total == 0 {
            return "--"
        } else {
            return String(total)
        }
    }
}
