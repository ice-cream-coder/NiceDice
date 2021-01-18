//
//  Settings.swift
//  NiceDice
//
//  Created by Roy Dawson on 1/18/21.
//  Copyright © 2021 Roy Dawson. All rights reserved.
//

import Foundation

class Settings {

    static var showSettings: Bool {
        get {
            UserDefaults.standard.value(forKey: "showSettings") as? Bool ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "showSettings")
        }
    }

    static var showHistory: Bool {
        get {
            UserDefaults.standard.value(forKey: "showHistory") as? Bool ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "showHistory")
        }
    }

    static var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.value(forKey: "theme") as? String ?? "black")!
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "theme")
        }
    }
}
