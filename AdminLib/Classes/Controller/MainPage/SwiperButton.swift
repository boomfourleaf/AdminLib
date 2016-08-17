//
//  SwiperButton.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/15/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit

@IBDesignable
class SwiperButton: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    
    func setColor(color:UIColor){
        fillColor = color
        fillColor.setFill()
    }
    
        override func drawRect(rect: CGRect) {
            var path = UIBezierPath(ovalInRect: rect)
            fillColor.setFill()
            path.fill()
            
            let plusHeight: CGFloat = 3.0
            let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
            
            
            
            var plusPath = UIBezierPath()
            
            plusPath.lineWidth = plusHeight
            
            
            plusPath.moveToPoint( CGPoint(
                x:bounds.height/2 - plusWidth/2,
                y:bounds.height/2)
            )
            
            
            plusPath.addLineToPoint( CGPoint(
                x:bounds.width/2 - 2.5,
                y:(bounds.height/2)/2 - 2.5)
            )
            
            
            plusPath.moveToPoint( CGPoint(
                x:bounds.height/2 - plusWidth/2,
                y:bounds.height/2)
            )
            
            
            plusPath.addLineToPoint( CGPoint(
                x:bounds.width/2 - 2.5,
                y:(bounds.height/2) +  plusWidth/2)
            )
            
            
            //RIGHT
            
            plusPath.moveToPoint( CGPoint(
                x:bounds.height/2 + plusWidth/2,
                y:bounds.height/2)
            )
            
            
            plusPath.addLineToPoint( CGPoint(
                x:bounds.width/2 + 2.5 ,
                y:(bounds.height/2)/2 - 2.5)
            )
            
            
            plusPath.moveToPoint( CGPoint(
                x:bounds.height/2 + plusWidth/2,
                y:bounds.height/2)
            )
            
            
            plusPath.addLineToPoint( CGPoint(
                x:bounds.width/2 + 2.5,
                y:(bounds.height/2) +  plusWidth/2)
            )
            
            UIColor.whiteColor().setStroke()
            
            plusPath.stroke()
            
            
        
    }
    
    public override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?){
        
    }

    

}
