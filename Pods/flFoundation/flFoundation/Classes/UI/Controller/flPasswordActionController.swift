//
//  flPasswordActionController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/3/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

@objc public protocol flPasswordActionControllerDelegate {
    func passwordActionController(controller: flPasswordActionController, IsCorrect password: String!) -> Bool
}

public class flPasswordActionController: NSObject, flPasswordVCDelegate {
    public weak var masterVc: UIViewController?
    public var passwordFor: String?
    public var successTask: (()->Void)?
    public var cancelTask: (()->Void)?
    public var animated = true
    
    public weak var delegate: flPasswordActionControllerDelegate?
    
    public init(masterVc: UIViewController) {
        NSLog("init flPasswordActionController")
        self.masterVc = masterVc
        super.init()
    }
    
    deinit {
        NSLog("deinit flPasswordActionController")
    }

    public func show() {
        main {
            let passwordVc = PasswordStoryboard.newVC(.PasswordVC)
                
            passwordVc.modalPresentationStyle = .FormSheet
            passwordVc.modalTransitionStyle = .CoverVertical
            passwordVc.preferredContentSize = CGSize(width: 542, height: 549)
            passwordVc.delegate = self
            
            self.masterVc?.presentViewController(passwordVc, animated: true, completion: nil)
        }
    }

    public func passwordDidChange(vc: flPasswordVC, password: String) {
        if true == delegate?.passwordActionController(self, IsCorrect: password) {
            main {
                self.masterVc?.dismissViewControllerAnimated(self.animated, completion: { _ in
                    self.successTask?()
                    return
                })
            }
        }
    }
    
    public func passwordDidCancel(vc: flPasswordVC) {
        if nil == delegate { return }

        cancelTask?()
    }
}
