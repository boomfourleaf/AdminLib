//
//  flStaffApi.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/20/2559 BE.
//
//

import Foundation

public class flStaffListApi: flApi {
    public override init() {
        super.init()
        api = "setting/get_staff_list/[fuid]/[random]/"
    }
}

public class flStaffUpdateApi: flApi {
    public override init() {
        super.init()
        api = "setting/update_staff/[fuid]/[random]/"
    }
}

public class flStaffNewApi: flApi {
    public override init() {
        super.init()
        api = "setting/new_staff/[fuid]/[random]/"
    }
}

public class flStaffDeleteApi: flApi {
    public override init() {
        super.init()
        api = "setting/delete_staff/[fuid]/[random]/"
    }
}
