//
//  flPasswordVC.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/26/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import UIKit

@objc public protocol flPasswordVCDelegate {
    func passwordDidChange(vc: flPasswordVC, password: String)
    func passwordDidCancel(vc: flPasswordVC)
}

public class flPasswordVC: flVC {
    @IBOutlet var passwordLabel: UILabel! { didSet  {
        passwordLabel.text = localize("Password")
    } }

    @IBOutlet var cancelButton: UIButton! { didSet  {
        cancelButton.setTitle(localize("Cancel"), forState: .Normal)
    } }

    public lazy var calculator = flCalculator()
    public weak var delegate: flPasswordVCDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        trackOpen("popover", name: "Cashier Password")
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.superview?.bounds = CGRectMake(0, 0, 542, 549)
    }
    
    public func initScreen() {
        calculator.vc = self
        // Numpad
        flCalculator.initNumpad(self, view:view, forAction:#selector(flPasswordVC.hitCalPad(_:)))
        // Init Num Pad Hilight
        flCalculator.initNumpadHilight(self.view)
        
        // Cancel/Confirm button corner radius
        let cancelView = view.viewWithTag(1002)
        cancelView?.cornerRadius(Config.DINING_PASSWORD_ACTION_BORDER_RADIUS)
        
        calculator.disablePointDecimal()
    }
    
    public func hitCalPad(sender: UIControl) {
        background {
            self.calculator.processNumpadForTag(sender.tag)
            
            self.delegate?.passwordDidChange(self, password:self.calculator.text)
            main { self.updateDisplay() }
        }
    }
    
    public func updateDisplay() {
        let changeLabel = view.labelWithTag(402)
        changeLabel?.text = String(count: calculator.text.characters.count, repeatedValue: Character("*"))
    }
    
    @IBAction func hitCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.passwordDidCancel(self)
    }
}

extension flPasswordVC {
    struct Config {
        static let DINING_PASSWORD_ACTION_BORDER_RADIUS = CGFloat(22.0)

    }
}
