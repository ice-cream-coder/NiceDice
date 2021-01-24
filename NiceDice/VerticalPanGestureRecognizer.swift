//
//  VerticalPanGestureRecognizer.swift
//  NiceDice
//
//  Created by Roy Dawson on 1/23/21.
//  Copyright © 2021 Roy Dawson. All rights reserved.
//

import UIKit

class VerticalPanGestureRecognizer: UIPanGestureRecognizer {

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if state == .began {
            let vel = velocity(in: view)
            if abs(vel.x) > abs(vel.y) {
                state = .cancelled
            }
        }
    }
}
