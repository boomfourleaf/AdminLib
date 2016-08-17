//
//  ReciptSettingViewController.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 6/15/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import UIKit
import flFoundation

protocol ReceiptDataCenterProtocol{
    
}

protocol ReceiptModel:ReceiptDataCenterProtocol{
    func save(flReceipt:flReceiptData?)
}

protocol ReceiptView:ReceiptDataCenterProtocol{
    func renderReceiptWithflReceiptData(flReceipt:flReceiptData)
}

class ReciptSettingViewController: UIViewController {
    
    @IBOutlet weak var leafViewController: UIView!
    @IBOutlet weak var rightViewController: UIView!
    private var attachmentBehavior: UIAttachmentBehavior!
    @IBOutlet weak var showOrHideRightViewbutton: UIBarButtonItem!
    
    var rightView : RightViewController?
    var showingReceipt:Bool = false
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    
    var flReceipt:flReceiptData?

    @IBOutlet weak var widthContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        // Show Full page leftView first
        widthContraint.constant  = self.view.frame.width
        
        // About Set navigation title text for first
        navigationItem.rightBarButtonItem?.title = "Show Result"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.1, delay: 0.5, options: .CurveEaseOut, animations: {
            self.widthContraint.constant += UIScreen.mainScreen().bounds.width
            self.view.layoutIfNeeded()
            }, completion: { finished in
                print("")
        })
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "leftViewController"{
            let destination = segue.destinationViewController as! ReciptLeftViewController
            destination.delegate = self
        }
        
        if segue.identifier == "rightViewController"{
            let destination = segue.destinationViewController as! RightViewController
            rightView = destination
        }
    }
}

//Remark:- About Show and Hide Example receipt
extension ReciptSettingViewController{
    
    // Button Action
    @IBAction func onShowHideReceipt(sender: AnyObject) {
        showingReceipt = !showingReceipt
        if showingReceipt {
            navigationItem.rightBarButtonItem?.title = "Hide"
            widthContraint.constant  = 0
            hideReceiptAnimate()
        }else{
            navigationItem.rightBarButtonItem?.title = "Show"
            widthContraint.constant  = self.view.frame.width
            showReceiptAnimate()
        }
    }
    
    func showReceiptAnimate(){
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn , animations: {
            self.widthContraint.constant += UIScreen.mainScreen().bounds.width
            self.view.layoutIfNeeded()
            }, completion: { finished in
                print("")
        })
    }
    
    func hideReceiptAnimate(){
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            self.widthContraint.constant -= UIScreen.mainScreen().bounds.width
            self.view.layoutIfNeeded()
            }, completion: { finished in
                print("")
        })
    }
}


extension ReciptSettingViewController: ReceiptModel{
    func save(flReceiptValue: flReceiptData?) {
        flReceipt = flReceiptValue
        if let flReceipt = flReceiptValue{
            if let right = rightView{
                right.renderReciept(flReceipt)
            }
        }
    }
}

