//
//  GroupUpdateWhitelistParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/26/21.
//

import UIKit
import ObjectMapper

class GroupUpdateWhitelistParam: NSObject, Mappable {
    var group_id: String?
    var white_list: [String] = []
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        group_id <- map["group_id"]
        white_list <- map["white_list"]
    }
}
