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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch Theme.current {
        case .black, .blue, .green, .red, .purple, .olive:
            return .lightContent
        default:
            if #available(iOS 13, *) {
                return .darkContent
            }
            return .default
        }
    }
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ContainerViewController.keyboardWillMove),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ContainerViewController.keyboardWillMove),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillMove(sender: NSNotification) {
        guard   let userInfo = sender.userInfo,
//                let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                let curveConstant = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
                let curve = UIView.AnimationCurve(rawValue: curveConstant),
                let c = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue,
            
                let window = UIApplication.shared.keyWindow,
                let rootView = window.rootViewController?.view else { return }
        
        let frame = self.container.convert(self.container.frame, to: rootView)
        let distanceFromScreenBottom = frame.maxY + self.bottomeAnchor.constant - rootView.frame.maxY
        let keyboardEndHeight = rootView.frame.height - endFrame.minY
        let bottomConstant = max(0, keyboardEndHeight - distanceFromScreenBottom)
        let co = UIView.AnimationOptions(rawValue: c << 16)
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: 0.0, options: co, animations: {
            
            self.bottomeAnchor.constant = bottomConstant
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard   let userInfo = sender.userInfo,
            //                let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curveConstant = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
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
