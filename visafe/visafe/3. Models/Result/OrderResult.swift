//
//  OrderResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/12/21.
//

import UIKit
import ObjectMapper

class OrderResult: Mappable {

    var error_code: Int = 0
    var local_message: String?
    var message: String?
    var orderId: String?
    var payUrl: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        error_code <- map["error_code"]
        local_message <- map["local_message"]
        message <- map["message"]
        orderId <- map["orderId"]
        payUrl <- map["payUrl"]
    }
}

