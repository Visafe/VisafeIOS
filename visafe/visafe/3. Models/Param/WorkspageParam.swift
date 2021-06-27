//
//  WorkspageParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import ObjectMapper

class WorkspageParam: NSObject, Mappable {
    var name: String?
    var type: WorkspaceTypeEnum?
    var phishingEnabled: Bool?
    var malwareEnabled: Bool?
    var logEnabled: Bool?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
        phishingEnabled <- map["phishingEnabled"]
        malwareEnabled <- map["malwareEnabled"]
        logEnabled <- map["logEnabled"]
    }
}
