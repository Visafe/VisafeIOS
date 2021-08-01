//
//  InviteToGroupParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import ObjectMapper

class InviteToGroupParam: NSObject, Mappable {
    var usernames: [String]?
    var groupID: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        usernames <- map["usernames"]
        groupID <- map["groupID"]
    }
}

