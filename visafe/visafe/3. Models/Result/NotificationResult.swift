//
//  NotificationResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit
import ObjectMapper

class NotificationResult: BaseResult {
    
    var notis: [NotificationModel]?
    var count: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        notis <- map["notis"]
        count <- map["count"]
    }
}
