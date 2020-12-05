//
//  DiceRole.swift
//  Nice Dice
//
//  Created by Roy Dawson on 1/2/18.
//  Copyright © 2018 Roy Dawson. All rights reserved.
//

import Foundation

class Dice {
    
    static var types : [UInt32] = [4, 6 , 8, 10, 12, 20]
    
    var dice = [UInt32:UInt32]()
    var modifier = 0
    
    init() {}
    
    init(dice : [UInt32:UInt32], modifier : Int) {
        self.dice = dice
        self.modifier = modifier
    }
    
    subscript(index: UInt32) -> UInt32? {
        get {
            return dice[index]
        }
        set(newValue) {
            dice[index] = newValue
        }
    }
}

class _Roll {
    
    var dice = Dice()
    var quickDice = Dice()
    var total : Int = 0
    var rand = arc4random_uniform
    
    init() {}
    
    init(dice: Dice) {
        self.dice = dice
        _ = self.roll()
    }
    
    init(dice: Dice, rand: @escaping ((UInt32) -> UInt32) = arc4random_uniform) {
        self.dice = dice
        self.rand = rand
        _ = self.roll()
    }
    
    func roll() -> Int {
        self.total = 0
        for (die, count) in dice.dice {
            for _ in 0..<count {
                total += Int(rand(die) + 1)
            }
        }
        self.total += self.dice.modifier
        return self.total
    }
    
    func add(_ die: UInt32) -> Int {
        self.total += Int(rand(die) + 1)
        
        if let _ = self.dice[die] {
            self.dice[die]! += 1
        } else {
            self.dice[die] = 1
        }
        
        return self.total
    }
    
    func changeModifier(to value: Int) -> Int {
        self.total += value - dice.modifier
        
        return self.total
    }
    
    func quickadd(_ count: UInt32, d die: UInt32) {
        if count == 0 {
            self.quickDice = Dice()
        } else {
            self.quickDice[die] = count
        }
    }
    
    func finalize() {
        for (die, count) in self.quickDice.dice {
            for _ in 0..<count {
                _ = self.add(die)
            }
        }
        self.quickDice = Dice()
    }
    
    func toString() -> String {
        if dice.dice.count == 0 && quickDice.dice.count == 0 {
            return ""
        }
        
        var string = ""
        for die in Dice.types {
            let count = self.dice[die] ?? 0
            let quickCount = self.quickDice[die] ?? 0
            let totalCount =  count + quickCount
            
            if totalCount == 0 {
                continue
            }
            
            string += String(totalCount) + "d" + String(die) + " + "
        }
        
        if self.dice.modifier == 0 {
            let index = string.index(string.endIndex, offsetBy: -3)
            return String(string[..<index])
        } else {
            return string + String(self.dice.modifier)
        }
    }
}
