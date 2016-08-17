//
//  flActionParser.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/7/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public struct flActionParser {
    var actions: [(action: String, value: String)]
    
    init(actions actionsStr: String) {
        actions = flActionParser.parse(actionsStr)
    }
    
    public func getValue(action: String) -> String? {
        guard let index = actions.indexOf({ action == $0.action }) else { return nil }
        return actions[index].value
    }
    
    public func isAction(action: String, equalToValue value: String) -> Bool {
        guard let valueToCheck = getValue(action) else { return false }
        return value == valueToCheck
    }
}

// MARK: - Private
extension flActionParser {
    // Action Parser
    private static func parse(actions: String) -> [(action: String, value: String)] {
        var output = [(action: String, value: String)]()
        for action in actions.componentsSeparatedByString(",") where "" != action {
            let keyValue = action.componentsSeparatedByString(":")
            if 2 == keyValue.count {
                output.append(
                    action: keyValue[0],
                    value: keyValue[1]
                )
            }
        }
        return output
    }
}

extension flActionParser {
    struct Config {
        static let flActionParserKeyAction = "action"
        static let flActionParserKeyValue = "value"
    }
}
