//
//  ALTabBarView.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/15/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

public protocol ALTabBarDelegate: class {
    func tabWasSelected(index: Int)
}

public class ALTabBarView: UIView {
    public weak var delegate: ALTabBarDelegate?
    public var selectedButton: UIButton?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    //Let the delegate know that a tab has been touched
    @IBAction public func touchButton(sender: UIButton) {
        if let delegateValue = delegate {
            selectedButton?.selected = false
            
            selectedButton = sender
            delegateValue.tabWasSelected(sender.tag - 100)
            
            selectedButton?.selected = true
        }
    }
    
    public func updateFrame() {
        
    }
}
