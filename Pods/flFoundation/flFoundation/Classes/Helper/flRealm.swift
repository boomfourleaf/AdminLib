//
//  flRealm.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/8/2559 BE.
//
//

import Foundation
import RealmSwift
import SwiftyJSON

public struct flRealm {
    public static func run(task: (realm: Realm) throws -> Void, success: (() -> Void)?=nil, failed: (() -> Void)?=nil) {
        do {
            let realm = try Realm()
            try task(realm: realm)
            success?()
            
        } catch let errorValue as NSError {
            flLog.error("error Realm \(errorValue.localizedDescription)")
            failed?()
        } catch {
            flLog.error("Unknown error")
            failed?()
        }
    }
}
