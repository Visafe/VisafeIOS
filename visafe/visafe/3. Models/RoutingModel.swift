//
//  RoutingModel.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 22/10/2021.
//

import UIKit
import ObjectMapper

class RoutingModel: NSObject, Mappable {
    var hostname: String?

    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        hostname <- map["hostname"]
    }
}
