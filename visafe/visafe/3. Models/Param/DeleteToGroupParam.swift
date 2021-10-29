//
//  DeleteToGroupParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import ObjectMapper

class DeleteToGroupParam: NSObject, Mappable {
    var userId: String?
    var groupID: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        groupID <- map["groupID"]
    }
}
