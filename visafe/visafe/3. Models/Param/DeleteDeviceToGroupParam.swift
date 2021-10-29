//
//  DeleteDeviceToGroupParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import ObjectMapper

class DeleteDeviceToGroupParam: NSObject, Mappable {
    var deviceId: String?
    var groupId: String?
    var deviceMonitorID: Int?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        deviceId <- map["deviceId"]
        groupId <- map["groupId"]
        deviceMonitorID <- map["deviceMonitorID"]
    }
}
