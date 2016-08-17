//
//  flScreenScale.swift
//  FOURLEAFCore
//
//  Created by Nattapon Nimakul on 12/21/2558 BE.
//  Copyright © 2558 Aspsolute Soft. All rights reserved.
//

import Foundation

public enum flScreenScale {
    case Scale1x,
    Scale2x
    
    var suffixString: String {
        switch flScreenScale.mainScreenScale {
        case .Scale2x: return "2x"
        case .Scale1x: return ""
        }
    }
    
    static let mainScreenScale: flScreenScale = UIScreen.mainScreen().scale == 2.00 ? .Scale2x : .Scale1x
}
