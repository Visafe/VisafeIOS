//
//  GenDeviceResult.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 04/08/2021.
//

import Foundation
import ObjectMapper

class GenDeviceResult: Mappable {

    var deviceId: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        deviceId <- map["deviceId"]
    }
}
