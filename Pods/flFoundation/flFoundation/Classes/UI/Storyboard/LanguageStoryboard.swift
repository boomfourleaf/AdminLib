//
//  LanguageStoryboard.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/19/2559 BE.
//
//

import UIKit


public struct LanguageStoryboardId<T> : flStoryboardIdProtocol {
    public typealias viewControllerType = T
    public var identifier: String
    
    public static var picker: LanguageStoryboardId<flPickerVC> { return LanguageStoryboardId<flPickerVC>(identifier: "Language Selector VC") }
}

public struct LanguageStoryboard: flStoryboardProtocol {
    public static let storyboard = UIStoryboard(name: "Language", bundle: FOURLEAFFoundationBundle.mainBundle)
    
    public static func newVC<viewControllerType>(vcIdentifier: LanguageStoryboardId<viewControllerType>) -> viewControllerType {
        return newVCWithVCIdentifier(vcIdentifier)
    }
}
