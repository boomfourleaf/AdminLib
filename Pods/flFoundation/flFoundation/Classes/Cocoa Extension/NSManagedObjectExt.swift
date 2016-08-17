//
//  NSManagedObjectExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 10/1/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public class func newObj(context: NSManagedObjectContext) -> NSManagedObject {
        let name = NSStringFromClass(self).componentsSeparatedByString(".").last!
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)
        let order = self.init(entity: entity!, insertIntoManagedObjectContext: context)
        return order
    }
    
    public class func newEntity(context: NSManagedObjectContext) -> NSEntityDescription? {
        let name = NSStringFromClass(self).componentsSeparatedByString(".").last!
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)
        return entity
    }
}
