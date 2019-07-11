//
//  ContainerViewController.swift
//  Nice Dice
//
//  Created by Roy Dawson on 7/10/19.
//  Copyright © 2019 Roy Dawson. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet var bottomeAnchor: NSLayoutConstraint!
    @IBOutlet var container: UIView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ContainerViewController.keyboardWillMove),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ContainerViewController.keyboardWillMove),
            name: NSNotification.Name.UIKeyboardDidHide,
            object: nil)
        
    }
    
    @objc func keyboardWillMove(sender: NSNotification) {
        guard   let userInfo = sender.userInfo,
//                let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                let curveConstant = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
                let curve = UIViewAnimationCurve(rawValue: curveConstant),
                let window = UIApplication.shared.keyWindow,
                let rootView = window.rootViewController?.view else { return }
        
        let frame = self.container.convert(self.container.frame, to: rootView)
        let distanceFromScreenBottom = frame.maxY + self.bottomeAnchor.constant - rootView.frame.maxY
        let keyboardEndHeight = rootView.frame.height - endFrame.minY
        let bottomConstant = max(0, keyboardEndHeight - distanceFromScreenBottom)
        print("--")
        print(duration)
        print(bottomConstant)
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            self.bottomeAnchor.constant = bottomConstant
        }
        animator.startAnimation()
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard   let userInfo = sender.userInfo,
            //                let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curveConstant = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let curve = UIView.AnimationCurve(rawValue: curveConstant),
            let window = UIApplication.shared.keyWindow,
            let rootView = window.rootViewController?.view else { return }
        
        let frame = self.container.convert(self.container.frame, to: rootView)
        
        let distanceFromScreenBottom = frame.maxY - rootView.frame.maxY
        let keyboardEndHeight = rootView.frame.height - endFrame.minY
        let bottomConstant = max(0, keyboardEndHeight - distanceFromScreenBottom)

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            self.bottomeAnchor.constant = bottomConstant
        }
        animator.startAnimation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
