//
//  flVC+Error.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation


//MARK: - Error & Warning
public func warningNoData() {
    let manager = flErrorManager(title: "Empty", description: "The order list is empty")
    manager.showAlert()
}

public func warningNoSign() {
    let manager = flErrorManager(title: "Your Signature is Required", description: "Please sign your Signature with your Finger")
    manager.showAlert(cancelText: "OK")
}

private func showApiError(status: Int, statusMsg: String, description: String) {
    let manager = flErrorManager(title: "\(statusMsg) (\(status))", description: description)
    manager.showAlert()
}

public func showOrderFailedWithError(error: flApiError) {
    switch error {
        case let .NoMessage(code):
            showApiError(code, statusMsg: flApiError.YOUR_ORDER_FAILED_TITLE, description: flApiError.YOUR_ORDER_FAILED_DESCRIPTION)

        case let .WithMessage(code, title, description):
            showApiError(code, statusMsg: title, description: description)

        case let .UnknowWithMessage(title, description):
            showApiError(flApiError.UNKNOW_ERROR_CODE, statusMsg: title, description: description)
    }
}

public func showFailedWithError(error: flApiError) {
    switch error {
    case let .NoMessage(code):
        showApiError(code, statusMsg: flApiError.SERVER_ERROR_TITLE, description: flApiError.SERVER_ERROR_DESCRIPTION)
        
    case let .WithMessage(code, title, description):
        showApiError(code, statusMsg: title, description: description)
        
    case let .UnknowWithMessage(title, description):
        showApiError(flApiError.UNKNOW_ERROR_CODE, statusMsg: title, description: description)
    }
}

public func showAlert(title: String, message msg: String?=nil) {
    let manager = flErrorManager(title: title, description: String(orEmpty: msg))
    manager.showAlert()
}


