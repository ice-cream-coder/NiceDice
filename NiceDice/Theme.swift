//
//  Theme.swift
//  NiceDice
//
//  Created by Roy Dawson on 11/26/20.
//  Copyright © 2020 Roy Dawson. All rights reserved.
//

import UIKit

enum Theme {
    
    case black
    case blue
    case green
    case yellow
    case brown
    case red
    case purple
    case pink
    case tan
    case olive
    case white
    
    static var current = Theme.black
    
    mutating func toggle() {
        switch self {
        case .black:
            self = .blue
        case .blue:
            self = .green
        case .green:
            self = .yellow
        case .yellow:
            self = .brown
        case .brown:
            self = .red
        case .red:
            self = .purple
        case .purple:
            self = .pink
        case .pink:
            self = .tan
        case .tan:
            self = .olive
        case .olive:
            self = .white
        case .white:
            self = .black
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .black:
            return .white
        case .blue:
            return UIColor(red: 242.0 / 255.0, green: 116.0 / 255.0, blue: 94.0 / 255.0, alpha: 1)
        case .green:
            return UIColor(red: 191.0 / 255.0, green: 164.0 / 255.0, blue: 193.0 / 255.0, alpha: 1)
        case .yellow:
            return UIColor(red: 70.0 / 255.0, green: 106.0 / 255.0, blue: 122.0 / 255.0, alpha: 1)
        case .brown:
            return UIColor(red: 77.0 / 255.0, green: 77.0 / 255.0, blue: 38.0 / 255.0, alpha: 1)
        case .red:
            return UIColor(red: 188.0 / 255.0, green: 218 / 255.0, blue: 54.0 / 255.0, alpha: 1)
        case .purple:
            return UIColor(red: 231.0 / 255.0, green: 82.0 / 255.0, blue: 92.0 / 255.0, alpha: 1)
        case .pink:
            return UIColor(red: 6.0 / 255.0, green: 122.0 / 255.0, blue: 53.0 / 255.0, alpha: 1)
        case .tan:
            return UIColor(red: 9.0 / 255.0, green: 6.0 / 214.0, blue: 214.0 / 255.0, alpha: 1)
        case .olive:
            return UIColor(red: 164.0 / 255.0, green: 132.0 / 255.0, blue: 61.0 / 255.0, alpha: 1)
        case .white:
            return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .black:
            return .black
        case .blue:
            return UIColor(red: 16.0 / 255.0, green: 67.0 / 255.0, blue: 156.0 / 255.0, alpha: 1)
        case .green:
            return UIColor(red: 63.0 / 255.0, green: 81.0 / 255.0, blue: 37.0 / 255.0, alpha: 1)
        case .yellow:
            return UIColor(red: 185.0 / 255.0, green: 159.0 / 255.0, blue: 43.0 / 255.0, alpha: 1)
        case .brown:
            return UIColor(red: 198.0 / 255.0, green: 136.0 / 255.0, blue: 111.0 / 255.0, alpha: 1)
        case .red:
            return UIColor(red: 204.0 / 255.0, green: 77.0 / 255.0, blue: 35.0 / 255.0, alpha: 1)
        case .purple:
            return UIColor(red: 77.0 / 255.0, green: 1.0 / 255.0, blue: 148.0 / 255.0, alpha: 1)
        case .pink:
            return UIColor(red: 238.0 / 255.0, green: 197.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
        case .tan:
            return UIColor(red: 227.0 / 255.0, green: 203.0 / 255.0, blue: 187.0 / 255.0, alpha: 1)
        case .olive:
            return UIColor(red: 49.0 / 255.0, green: 59.0 / 255.0, blue: 48.0 / 255.0, alpha: 1)
        case .white:
            return .white
        }
    }
    
}
