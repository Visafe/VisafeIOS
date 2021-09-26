//
//  DeviceCheckResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 9/26/21.
//

import Foundation
import ObjectMapper

class DeviceCheckResult: Mappable {

    var status_code: Int?
    var groupId: String?
    var groupName: String?
    var groupOwner: String?
    var numberDevice: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status_code <- map["status_code"]
        groupId <- map["groupId"]
        groupName <- map["groupName"]
        groupOwner <- map["groupOwner"]
        numberDevice <- map["numberDevice"]
    }
}
