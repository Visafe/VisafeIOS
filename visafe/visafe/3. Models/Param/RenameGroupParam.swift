//
//  RenameGroupParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import ObjectMapper

class RenameGroupParam: NSObject, Mappable {
    var group_id: String?
    var group_name: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        group_id <- map["group_id"]
        group_name <- map["group_name"]
    }
}
