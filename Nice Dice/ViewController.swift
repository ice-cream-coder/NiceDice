//
//  ViewController.swift
//  Nice Dice
//
//  Created by Roy Dawson on 1/2/18.
//  Copyright © 2018 Roy Dawson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var roll = Roll()
    var lastAdded : UInt32 = 0
    var lastPress = Date()
    
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    var orignalTransform : CGAffineTransform = CGAffineTransform()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orignalTransform = totalLabel.transform
        self.updateLabels();
    }
    
    
    func updateLabels(animate: Bool = true) {
        self.rollLabel.text = roll.toString()
        self.totalLabel.text = roll.total == 0 ? "--" : String(roll.total)
        if animate {
            self.totalLabel.transform = self.orignalTransform.scaledBy(x: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.5, animations: {
                self.totalLabel.transform = self.orignalTransform
            })
        }
    }
    
    @IBAction func add_d4(_ sender: Any) {
        add(4)
    }
    @IBAction func add_d6(_ sender: Any) {
        add(6)
    }
    @IBAction func add_d8(_ sender: Any) {
        add(8)
    }
    @IBAction func add_d10(_ sender: Any) {
        add(10)
    }
    @IBAction func add_d12(_ sender: Any) {
        add(12)
    }
    @IBAction func add_d20(_ sender: Any) {
        add(20)
    }
    
    func add(_ n: UInt32) {
        if lastAdded != n || lastPress.timeIntervalSinceNow < -0.75 {
            roll = Roll()
        }
        lastPress = Date()
        
        _ = roll.add(UInt32(n))
        lastAdded = n
        self.updateLabels()
    }
    
    @IBAction func swipeUpD4(_ sender: UIPanGestureRecognizer) {
        self.swipeUp(sender, 4)
    }
    @IBAction func swipeUpD6(_ sender: UIPanGestureRecognizer) {
        self.swipeUp(sender, 6)
    }
    @IBAction func swipeUpD8(_ sender: UIPanGestureRecognizer) {
        self.swipeUp(sender, 8)
    }
    @IBAction func swipeUpD10(_ sender: UIPanGestureRecognizer) {
        self.swipeUp(sender, 10)
    }
    @IBAction func swipeUpD12(_ sender: UIPanGestureRecognizer) {
        self.swipeUp(sender, 12)
    }
    @IBAction func swipeUpD20(_ sender: UIPanGestureRecognizer) {
        self.swipeUp(sender, 20)
    }
    
    var startLocation : CGPoint = CGPoint.zero
    func swipeUp(_ sender: UIPanGestureRecognizer, _ die: UInt32) {
        if (sender.state == UIGestureRecognizer.State.began) {
            roll = Roll()
            self.startLocation = sender.location(in: self.view)
        }
        else {
            let currentLocation = sender.location(in: self.view)
            let yDistance =  self.startLocation.y - currentLocation.y
        
            let add = max(0, Int(yDistance / 10))
            
            roll.quickadd(UInt32(add), d: die)
            if(sender.state == UIGestureRecognizer.State.ended ) {
                roll.finalize()
                self.updateLabels()
            } else {
                self.updateLabels(animate: false)
            }
        }
        
        self.lastAdded = die
    }
    
    @IBAction func reset(_ sender: Any) {
        self.roll = Roll()
        self.updateLabels()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
}

