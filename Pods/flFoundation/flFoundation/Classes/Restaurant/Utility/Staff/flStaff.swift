//
//  flStaff.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/6/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct flStaff {
    public static func staffForPassword(password: String) -> ObjcDictionary? {
        guard let staffList = flStaffListConfigure.shareObject.staffs,
            let index = staffList.indexOf( { return JSON($0)[API_STAFF_PASSWORD].stringValue == password }) else { return nil }

        return staffList[index]
    }

}
