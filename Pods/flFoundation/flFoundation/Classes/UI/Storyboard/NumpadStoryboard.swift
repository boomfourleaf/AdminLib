//
//  NumpadStoryboard.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/16/2559 BE.
//
//

import UIKit

//MAKR: Main
public struct NumpadStoryboardId<T> : flStoryboardIdProtocol {
    public typealias viewControllerType = T
    public var identifier: String
    
    public static var NumpadVC: NumpadStoryboardId<flNumpadVC> { return NumpadStoryboardId<flNumpadVC>(identifier: "Numpad View Controller") }
}

public struct NumpadStoryboard: flStoryboardProtocol {
    public static let storyboard = UIStoryboard(name: "Numpad", bundle: FOURLEAFFoundationBundle.mainBundle)
    
    public static func newVC<viewControllerType>(vcIdentifier: NumpadStoryboardId<viewControllerType>) -> viewControllerType {
        return newVCWithVCIdentifier(vcIdentifier)
    }
}

