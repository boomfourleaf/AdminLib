//
//  Loading.swift
//  AdminApp
//
//  Created by Jakkapan Thongkum on 7/26/2559 BE.
//  Copyright © 2559 Jakkapan Thongkum. All rights reserved.
//

import Foundation
import UIKit
import flFoundation



class Loading{
    static var shareInstance = Loading()
    
    var loadingViewController:UIAlertController?

    func showLoding(view: UIViewController){
        if loadingViewController == nil {
            loadingViewController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
            
            loadingViewController!.view.tintColor = UIColor.blackColor()
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            loadingIndicator.startAnimating();
            loadingViewController!.view.addSubview(loadingIndicator)
            view.presentViewController(loadingViewController!, animated: true, completion: nil)
        }
    }
    
    func dissmissLoading(){
        if let alert = loadingViewController{
            alert.dismissViewControllerAnimated(false, completion: nil)
            loadingViewController = nil
        }
    }
    
    func dissmissLoad(view: UIViewController){
        view.dismissPresentedViewController(true)
    }
    
    
}