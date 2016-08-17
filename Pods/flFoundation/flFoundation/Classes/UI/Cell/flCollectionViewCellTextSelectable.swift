//
//  flCollectionViewCellTextSelectable.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/5/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

public class flCollectionViewCellTextSelectable: UICollectionViewCell {
    public let animatedDuration: NSTimeInterval = 0.2
    public let selectedBackgroundColor = UIColor(hex: 0xFDE162)
    public let selectedTextColor = UIColor(hex: 0x0077CC)
    public let unselectedBackgroundColor = UIColor.grayColor()
    public let unselectedTextColor = UIColor(hex: 0x000000)
    
    @IBOutlet public weak var containerView: UIView!
    @IBOutlet public weak var textLabel: UILabel!
    
    public override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        containerView.cornerRadius(22.0)
        updateDisplay()
    }
    
    public func updateDisplay() {
        let backgroudnColor = selected ? selectedBackgroundColor : unselectedBackgroundColor
        let textColor = selected ? selectedTextColor : unselectedTextColor
        
        Animate.duration(animatedDuration) {
            self.containerView.backgroundColor = backgroudnColor
            self.textLabel.textColor = textColor
        }.run()
    }
    
    public func updateHilight() {
        if highlighted {
            if selected {
                Animate.duration(animatedDuration) {
                       self.textLabel.textColor = self.unselectedTextColor
                }.run()
                
            } else {
                Animate.duration(animatedDuration) {
                      self.textLabel.textColor = self.selectedTextColor
                }.run()
            }
        }
    }
    
    public override var selected: Bool {
        didSet {
            NSLog("selected \(selected)")
            updateDisplay()
        }
    }
    
    public override var highlighted: Bool {
        didSet {
            NSLog("highlighted \(highlighted)")
            updateHilight()
        }
    }
}
