//
//  fourleafStoryboard.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/3/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

public struct FOURLEAFFoundationBundle {
    public static var mainBundle: NSBundle = {
        let path = NSBundle.mainBundle().resourcePath
        if nil == path {
            flLog.error("Can not get main bundle resource path")
        }
        
        var pathUrl = NSURL(fileURLWithPath: path!)
        pathUrl = pathUrl.URLByAppendingPathComponent("Frameworks")
        pathUrl = pathUrl.URLByAppendingPathComponent("flFoundation.framework")
        pathUrl = pathUrl.URLByAppendingPathComponent("flFoundation.bundle")
        
        let bundle = NSBundle(URL: pathUrl)
        if nil == bundle {
            flLog.error("Can not get bundle for \(pathUrl.absoluteString)")
        }
        
        return bundle!
    }()
    
    public static func resourceURLForFileName(fileName: String) -> NSURL? {
        return mainBundle.resourceURL?.URLByAppendingPathComponent( fileName )
    }
}

public protocol flStoryboardIdProtocol {
    associatedtype viewControllerType
    
    var identifier: String { get }
}

public protocol flStoryboardProtocol {
    static var storyboard: UIStoryboard { get }
}

extension flStoryboardProtocol {
    public static func newVCWithVCIdentifier<T: flStoryboardIdProtocol>(vcIdentifier: T) -> T.viewControllerType {
        return storyboard.instantiateViewControllerWithIdentifier(vcIdentifier.identifier) as! T.viewControllerType
    }
}

//MARK: Framework Storyboard
public struct flFrameworkStoryboardId<T> : flStoryboardIdProtocol {
    public typealias viewControllerType = T
    public var identifier: String
    
    //    static var LogView: flFrameworkStoryboardId<DiningLogVC> { return flFrameworkStoryboardId<DiningLogVC>(identifier: "Log View") }
    public static var MessageOverlay: flFrameworkStoryboardId<UIViewController> { return flFrameworkStoryboardId<UIViewController>(identifier: "Fourleaf Message Overlay") }
    public static var LoadingOverlay: flFrameworkStoryboardId<flLoadingScreenVC> { return flFrameworkStoryboardId<flLoadingScreenVC>(identifier: "Fourleaf Loading Screen OVerlay") }
    public static var SignatureOverlay: flFrameworkStoryboardId<flSignatureVC> { return flFrameworkStoryboardId<flSignatureVC>(identifier: "Fourleaf Signature View") }
    public static var LicenseScreen: flFrameworkStoryboardId<UINavigationController> { return flFrameworkStoryboardId<UINavigationController>(identifier: "Fourleaf License Screen") }
    public static var StockMasterViewController: flFrameworkStoryboardId<StockSplitViewController> { return flFrameworkStoryboardId<StockSplitViewController>(identifier: "Stock Master View Controller") }
}

public struct flFrameworkStoryboard: flStoryboardProtocol {
    public static let storyboard = UIStoryboard(name: "fourleaf", bundle: FOURLEAFFoundationBundle.mainBundle)
    
    public static func newVC<viewControllerType>(vcIdentifier: flFrameworkStoryboardId<viewControllerType>) -> viewControllerType {
        return newVCWithVCIdentifier(vcIdentifier)
    }
}


//MAKR: Main
public struct mainStoryboardId<T> : flStoryboardIdProtocol {
    public typealias viewControllerType = T
    public var identifier: String
    
    public static var TableManagerSplitSection: mainStoryboardId<UIViewController> { return mainStoryboardId<UIViewController>(identifier: "Dining Table Manager Each Split Section") }
}

public struct mainStoryboard: flStoryboardProtocol {
    public static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    public static func newVC<viewControllerType>(vcIdentifier: mainStoryboardId<viewControllerType>) -> viewControllerType {
        return newVCWithVCIdentifier(vcIdentifier)
    }
}

