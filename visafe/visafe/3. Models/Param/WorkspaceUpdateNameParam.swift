//
//  WorkspaceUpdateNameParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import ObjectMapper

class WorkspaceUpdateNameParam: NSObject, Mappable {
    var workspace_id: String?
    var workspace_name: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        workspace_id <- map["workspace_id"]
        workspace_name <- map["workspace_name"]
    }
}
