//
//  PasswordStoryboard.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/16/2559 BE.
//
//

import UIKit

//MAKR: Main
public struct PasswordStoryboardId<T> : flStoryboardIdProtocol {
    public typealias viewControllerType = T
    public var identifier: String
    
    public static var PasswordVC: PasswordStoryboardId<flPasswordVC> { return PasswordStoryboardId<flPasswordVC>(identifier: "Dining Password VC") }
}

public struct PasswordStoryboard: flStoryboardProtocol {
    public static let storyboard = UIStoryboard(name: "Password", bundle: FOURLEAFFoundationBundle.mainBundle)
    
    public static func newVC<viewControllerType>(vcIdentifier: PasswordStoryboardId<viewControllerType>) -> viewControllerType {
        return newVCWithVCIdentifier(vcIdentifier)
    }
}

