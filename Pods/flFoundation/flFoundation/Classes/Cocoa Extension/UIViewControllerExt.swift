//
//  UIViewControllerExt.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/18/2559 BE.
//
//

import UIKit

extension UIViewController {
    public func dismissPresentedViewController(animation: Bool) {
        // Dismiss exciting any presented view controller on top if any
        if let presentedViewControllerValue = presentedViewController where !presentedViewControllerValue.isBeingDismissed() {
            presentedViewControllerValue.dismissViewControllerAnimated(animation, completion: nil)
        }
    }
}
