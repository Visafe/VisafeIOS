//
//  VersioniOSModel.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 12/08/2021.
//

import UIKit
import ObjectMapper

class VersioniOSModel: NSObject, Mappable {
    var version: String?

    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        version <- map["version"]
    }
}
