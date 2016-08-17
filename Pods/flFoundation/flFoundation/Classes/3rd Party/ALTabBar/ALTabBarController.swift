//
//  ALTabBarController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/15/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit
import flFoundation

public class ALTabBarController: UITabBarController {
    @IBOutlet public weak var customTabBarView: ALTabBarView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTabbar()
    }
    
    public func prepareTabbar() {
        
    }
    
    public func displayCustomTabBar(customTabBar: ALTabBarView)  {
        guard let subviews = view?.subviews else { return }
        for view in subviews {
            if let tabbar = view as? UITabBar {
                tabbar.addSubview(customTabBarView)
                //                [self.view addConstraint:[NSLayoutConstraint
                //                                          constraintWithItem:self.customTabBarView
                //                                          attribute:NSLayoutAttributeBottom
                //                                          relatedBy:NSLayoutRelationEqual
                //                                          toItem:view
                //                                          attribute:NSLayoutAttributeBottom
                //                                          multiplier:1.0
                //                                          constant:0.0]];
                
                break
            }
        }
    }
    
    public func hideExistingTabBar() {
        guard let subviews = view?.subviews else { return }
        for view in subviews {
            if let _ = view as? UITabBar {
                view.hidden = true
                break
            }
        }
    }
    
    
    public func switchToTab(index: Int)  {
        if let switchTabTabButton = customTabBarView.viewWithTag(index + 100) as? UIButton {
            flLog.info("switchTabTabButton \(switchTabTabButton)")
            customTabBarView.touchButton(switchTabTabButton)
        }
    }

    public func popToRootViewForTab(index: Int) {
        // Pop to root view if in current tab
        if let navCon = viewControllers?[index] as? UINavigationController {
            main {
                navCon.popToRootViewControllerAnimated(false)
            }
        }
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        customTabBarView.updateFrame()
    }
}

extension ALTabBarController: ALTabBarDelegate {
    public func tabWasSelected(index: Int) {
        // Pop to root view if in current tab
        if selectedIndex == index {
            if let navCon = viewControllers?[index] as? UINavigationController {
                main {
                    navCon.popToRootViewControllerAnimated(true)
                }
            }
        }
        
        
        selectedIndex = index
    }
}
