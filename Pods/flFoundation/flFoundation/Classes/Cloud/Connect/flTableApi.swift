//
//  flTableApi.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/22/2559 BE.
//
//

import Foundation


public class flTableListApi: flApi {
    public override init() {
        super.init()
        api = "setting/get_table_list/[fuid]/[random]/"
    }
}

public class flTableUpdateZoneApi: flApi {
    public override init() {
        super.init()
        api = "setting/update_table_zone/[fuid]/[random]/"
    }
}

public class flTableUpdateNameApi: flApi {
    public override init() {
        super.init()
        api = "setting/update_table_name/[fuid]/[random]/"
    }
}

public class flTableNewZoneApi: flApi {
    public override init() {
        super.init()
        api = "setting/new_table_zone/[fuid]/[random]/"
    }
}

public class flTableNewNameApi: flApi {
    public override init() {
        super.init()
        api = "setting/new_table_name/[fuid]/[random]/"
    }
}

public class flTableDeleteZoneApi: flApi {
    public override init() {
        super.init()
        api = "setting/delete_table_zone/[fuid]/[random]/"
    }
}

public class flTableDeleteNameApi: flApi {
    public override init() {
        super.init()
        api = "setting/delete_table_name/[fuid]/[random]/"
    }
}
