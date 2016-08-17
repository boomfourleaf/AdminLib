//
//  flLoadingScreenVC.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/7/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

public class flLoadingScreenVC: UIViewController {
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var fourleafImage: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    public var enableAnimation = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if enableAnimation {
            startAnimation()
        }
    }
    
}

//MARK: Public
extension flLoadingScreenVC {
    public func startAnimation() {
        animationStep1()
    }
    
    public func stopAnimation() {
        enableAnimation = false
    }
}

//MARK: Fourleaf Animation Controlelr
extension flLoadingScreenVC {
    
    private dynamic func animationStep1() {
        if enableAnimation {
            UIView.beginAnimations("fourleaf rotate", context:nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationCurve(.Linear)
            
            fourleafImage.transform = CGAffineTransformMakeRotation(CGFloat(0.5*M_PI))
            
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector(#selector(animationStep2))
            UIView.commitAnimations()
        }
    }
    
    private dynamic func animationStep2() {
        if enableAnimation {
            UIView.beginAnimations("fourleaf rotate", context:nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationCurve(.Linear)
            
            fourleafImage.transform = CGAffineTransformMakeRotation(CGFloat(1*M_PI))
            
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector(#selector(animationStep3))
            UIView.commitAnimations()
        }
    }
    
    private dynamic func animationStep3() {
        if enableAnimation {
            UIView.beginAnimations("fourleaf rotate", context:nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationCurve(.Linear)
            
            fourleafImage.transform = CGAffineTransformMakeRotation(CGFloat(1.5*M_PI))
            
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector(#selector(animationStep4))
            UIView.commitAnimations()
        }
    }
    
    private dynamic func animationStep4() {
        if enableAnimation {
            UIView.beginAnimations("fourleaf rotate", context:nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationCurve(.Linear)
            
            fourleafImage.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI))
            
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector(#selector(animationStep1))
            UIView.commitAnimations()
        }
    }
}