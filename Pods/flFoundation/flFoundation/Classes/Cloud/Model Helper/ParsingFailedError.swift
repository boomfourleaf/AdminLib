//
//  ParsingFailedError.swift
//  Pods
//
//  Created by Nattapon Nimakul on 7/5/2559 BE.
//
//

import Foundation
import SwiftyJSON

public struct ParsingFailedError: ErrorType {
    public let attribute: String
    public let message: String
}

extension ParsingFailedError {
    public init(attribute: String, json: JSON) {
        self.init(attribute: attribute, message: "Parsing failed at attribute \"\(attribute)\" from source \(json)")
    }
}
