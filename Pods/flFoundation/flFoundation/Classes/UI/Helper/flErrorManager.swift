//
//  flErrorManager.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/13/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

struct flErrorManager {
    var title = ""
    var description = ""
    
    func showAlert(delegate: AnyObject? = nil, cancelText: String = "Close") {
        let alert = UIAlertView(title: title, message: description, delegate: delegate, cancelButtonTitle: cancelText)
        alert.show()
    }
}
