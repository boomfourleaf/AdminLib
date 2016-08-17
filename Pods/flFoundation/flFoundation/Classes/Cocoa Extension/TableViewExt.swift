//
//  tableViewExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension UITableView {
    public func createCell(identifier: String?) -> UITableViewCell? {
        if let uwpidentifier = identifier {
            return self.dequeueReusableCellWithIdentifier(uwpidentifier)
        }
        return nil
    }
    
    public class func findTableviewCell(view: UIView?, maxDepth depth: Int) -> UITableViewCell? {
        if depth <= 0 {
            return nil
        } else {
            if view == nil {
                return nil
            } else if let cell = view as? UITableViewCell {
                return cell
            } else {
                return findTableviewCell(view?.superview, maxDepth: depth-1)
            }
        }
    }
}
