//
//  flVC+Order.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

public protocol flAppDelegateProtocol {
    var orderController: flOrderController { get }
}

extension flVC {
    //MARK: - OrderController
    public class func orderController() -> flOrderController? {
        let appDelegate = UIApplication.sharedApplication().delegate as? flAppDelegateProtocol
        return appDelegate?.orderController
    }
    
    public func reloadOrderListButtons(animate: Bool=true) {
        var buttons = [UIBarButtonItem]()
        if let topRightOrderButtons = navigationItem.rightBarButtonItems
            where topRightOrderButtons.count > 0 {
                let topRightOrderButton = topRightOrderButtons[0]
                if 0 == (flVC.orderController()?.list.count ?? 0) {
                    topRightOrderButton.tintColor = .whiteColor()
                    topRightOrderButton.setFontToNormal()
                    topRightOrderButton.title = localize("Order List")
                    
                } else {
                    topRightOrderButton.setHumanEyeFont()
                    topRightOrderButton.title = localize("Send")
                }
                
                buttons.append(topRightOrderButton)
        }
        
        // Setup Order Number View
        if let orderControllerValue = flVC.orderController()
            where orderControllerValue.list.count != 0 {
            // Set order number badged view
            let number = MKNumberBadgeView(frame: CGRectMake(0, 0, 40, 40))
            number.adjustOffset = CGPoint(x: 0, y: -2)
            number.value = UInt(orderControllerValue.itemCount())
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flVC.hitOrderListBadge(_:)))
            number.addGestureRecognizer(tapGesture)
            
            let proe = UIBarButtonItem(customView: number)
            buttons.append(proe)
        }
        
        // Replace Right Navigation Items
        navigationItem.setRightBarButtonItems(buttons, animated: animate)
    }
    
    public func hitOrderListBadge(sender: UIView) {
        
    }
}
