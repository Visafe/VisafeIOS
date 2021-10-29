//
//  DeleteDeviceToIdentifierParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import ObjectMapper

class DeleteDeviceToIdentifierParam: NSObject, Mappable {
    var deviceIds: [String]?
    var identifierId: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        deviceIds <- map["deviceIds"]
        identifierId <- map["identifierId"]
    }
}
