//
//  flReceiptApi.swift
//  Pods
//
//  Created by Nattapon Nimakul on 6/28/2559 BE.
//
//

import Foundation

public class flReceiptGetApi: flApi {
    public override init() {
        super.init()
        api = "setting/get_receipt/[fuid]/[random]/"
    }
}


public class flReceiptUpdateApi: flApi {
    public override init() {
        super.init()
        api = "setting/update_receipt/[fuid]/[random]/"
    }
}
