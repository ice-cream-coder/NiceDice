//
//  TintedLabel.swift
//  NiceDice
//
//  Created by Roy Dawson on 11/26/20.
//  Copyright © 2020 Roy Dawson. All rights reserved.
//

import UIKit

class TintedLabel: UILabel {
    
    override func tintColorDidChange() {
        self.textColor = tintColor
    }
}
