//
//  QueryLogParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit
import ObjectMapper

public enum QueryLogTypeEnum: String {
    case content_blocked = "content_blocked"
    case access_blocked = "access_blocked"
    case ads_blocked = "ads_blocked"
    case native_tracking = "native_tracking"
}

class QueryLogParam: NSObject, Mappable {
    var group_id: String?
    var workspace_id: String?
    var response_status: QueryLogTypeEnum?
    var older_than: String = ""
    var limit: Int?
    var search: String = ""
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        group_id <- map["group_id"]
        workspace_id <- map["workspace_id"]
        response_status <- map["response_status"]
        older_than <- map["older_than"]
        limit <- map["limit"]
        search <- map["search"]
    }
}
