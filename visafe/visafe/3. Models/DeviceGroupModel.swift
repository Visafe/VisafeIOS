//
//  DeviceGroupModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/26/21.
//

import UIKit
import ObjectMapper

class DeviceGroupModel: NSObject, Mappable {
    var groupID: String?
    var deviceID: String?
    var deviceName: String?
    var deviceType: DevcieTypeEnum?
    var deviceOwner: String?
    var deviceJoinState: String?
    var deviceDetail: String?
    var deviceActiveState: String?
    var deviceMonitorID: Int?
    var identifierId: String?
    var identifierName: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        groupID <- map["groupID"]
        deviceID <- map["deviceID"]
        deviceName <- map["deviceName"]
        deviceType <- map["DeviceType"]
        deviceOwner <- map["deviceOwner"]
        deviceJoinState <- map["deviceJoinState"]
        deviceDetail <- map["DeviceDetail"]
        deviceActiveState <- map["deviceActiveState"]
        deviceMonitorID <- map["deviceMonitorID"]
        identifierId <- map["identifierId"]
        identifierName <- map["identifierName"]
    }
}
