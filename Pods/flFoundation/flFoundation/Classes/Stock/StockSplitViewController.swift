//
//  StockSplitViewController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/27/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

public class StockSplitViewController: UISplitViewController {
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: TODO Check if iOS 9 fix this issue yet
        // Force call viewWillAppear when device is on portrait
        if .Landscape != flDevice.deviceOrientationForView(view) {
            if viewControllers.count >= 1 {
                viewControllers[0].viewWillAppear(animated)
            }
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //MARK: TODO Check if iOS 9 fix this issue yet
        // Force call viewDidAppear when device is on portrait
        if .Landscape != flDevice.deviceOrientationForView(view) {
            if viewControllers.count >= 1 {
                viewControllers[0].viewDidAppear(animated)
            }
        }
    }
}
