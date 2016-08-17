//
//  flStockApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/27/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

public class flStockItemListApi: flApi {
    public override init() {
        super.init()
        api = "stock/item_list/[random]/"
        parameters = []
    }
}

public class flStockItemTransactionListApi: flApi {
    public override init() {
        super.init()
        api = "stock/item_transaction_list/{0}/[random]/"
        parameters = []
    }
}

public class flStockItemNewTransactionApi: flApi {
    public override init() {
        super.init()
        api = "stock/item_add_transaction/[random]/"
        parameters = []
    }
}

public class flStockNewItemApi: flApi {
    public override init() {
        super.init()
        api = "stock/add_item/[random]/"
        parameters = []
    }
}
