//
//  DeleteDeviceGroupParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/1/21.
//

import UIKit
import ObjectMapper

class DeleteDeviceGroupParam: NSObject, Mappable {
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
