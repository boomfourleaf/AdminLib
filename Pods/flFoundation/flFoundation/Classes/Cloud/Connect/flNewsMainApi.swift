//
//  flNewsMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/25/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

// News
private var BANGKOK_POST_CODE        : String { return "BKP" }
private var THE_NATION_CODE          : String { return "TNT" }
private var CNN_CODE                 : String { return "CNN" }
private var AP_CODE                  : String { return "APP" }
private var THE_NEW_YROK_TIMES_CODE  : String { return "TNY" }
private var BBC_CODE                 : String { return "BBC" }
private var THE_WASHINGTON_POST_CODE : String { return "TWP" }
private var NBC_CODE                 : String { return "NBC" }
private var ALJAZEERA_CODE           : String { return "ALJ" }

public class flNewsMainApi: flApi {
    public override init() {
        super.init()
        api = "feed/get_news/{0}/{1}/[random]/"
        parameters = ["1", "publisher"]
    }
    
    init(publisher: String) {
        super.init()
        api = "feed/get_news/{0}/{1}/[random]/"
        parameters = ["1", publisher];
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.NEWS, fileName:"news_\(parameters[1]).plist")
    }
}

public class flNewsBangkokPostApi: flNewsMainApi {
    public override init() {
        super.init(publisher: BANGKOK_POST_CODE)
    }
}

public class flNewsTheNationApi: flNewsMainApi {
    public override init() {
        super.init(publisher: THE_NATION_CODE)
    }
}

public class flNewsCNNApi: flNewsMainApi {
    public override init() {
        super.init(publisher: CNN_CODE)
    }
}

public class flNewsAPApi: flNewsMainApi {
    public override init() {
        super.init(publisher: AP_CODE)
    }
}

public class flNewsTheNewYorkTimesApi: flNewsMainApi {
    public override init() {
        super.init(publisher: THE_NEW_YROK_TIMES_CODE)
    }
}

public class flNewsBBCApi: flNewsMainApi {
    public override init() {
        super.init(publisher: BBC_CODE)
    }
}

public class flNewsTheWashingPostApi: flNewsMainApi {
    public override init() {
        super.init(publisher: THE_WASHINGTON_POST_CODE)
    }
}

public class flNewsNBCApi: flNewsMainApi {
    public override init() {
        super.init(publisher: NBC_CODE)
    }
}

public class flNewsAljazeeraApi: flNewsMainApi {
    public override init() {
        super.init(publisher: ALJAZEERA_CODE)
    }
}

