//
//  flMyroomMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

//MARK: Feedback
public class flMyroomFeedbackApi: flApi {
    public override init() {
        super.init()
        api = "myroom/get_feedback/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.FEED_BACK, fileName:"feedBack.plist")
    }
}

//MARK: Feedback Post
public class flMyroomFeedbackPostApi: flApi {
    public override init() {
        super.init()
        api = "myroom/post_feedback/[fuid]/"
    }
}

//MARK: Information
public class flMyroomInfoApi: flApi {
    public override init() {
        super.init()
        api = "admin/dashboard/get_information/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.MYROOM_INFO, fileName:"myroom_information.plist")
    }
}

//MARK: Message
public class flMyroomMsgApi: flApi {
    public override init() {
        super.init()
        api = "admin/dashboard/get_message/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.MESSAGE, fileName:"message.plist")
    }
}

//MARK: Mark read Message
public class flMyroomMsgSendMarkReadApi: flApi {
    public override init() {
        super.init()
        api = "service/message/mark/[fuid]/"
    }
}

//MARK: Order History
public class flMyroomOrderHisApi: flApi {
    public override init() {
        super.init()
        api = "order/order_history/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.ORDER_HISTORY, fileName:"orderHistoryList.plist")
    }
}

//MARK: Myroom Profile
public class flMyroomProfileApi: flApi {
    public override init() {
        super.init()
        api = "myroom/myroom_profile/[fuid]/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas][main]<picture>",
                "[datas][main]<myroom_main_background>",
                
                "[datas][main]<myroom_information_background>",
                "[datas][main]<myroom_information_panel_background>",
                
                "[datas][main]<myroom_message_background>",
                "[datas][main]<myroom_message_left_background>",
                "[datas][main]<myroom_message_right_panel_background>",
                
                "[datas][main]<myroom_history_background>",
                "[datas][main]<myroom_history_top_background>",
                "[datas][main]<myroom_history_cell_background>",
                "[datas][main]<myroom_history_cell_number_background>",
                "[datas][main]<myroom_history_more_detail_button>",
                
                "[datas][main]<myroom_feedback_background>",
                "[datas][main]<myroom_feedback_left_panel_background>",
                "[datas][main]<myroom_feedback_send_button>",
                "[datas][main]<myroom_feedback_comment_block>"]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.MYROOM_PROFILE, fileName:"myroomProfile.plist")
    }
}
