//
//  PaymentResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/12/21.
//

import UIKit
import ObjectMapper

class PaymentResult: BaseResult {
    var partnerCode: String?
    var accessKey: String?
    var requestId: String?
    var amount: String?
    var orderId: String?
    var orderInfo: String?
    var signature: String?
    var extraData: String?
    var transId: String?
    var localMessage: String?
    var errorCode: String?
    var message: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        partnerCode <- map["partnerCode"]
        accessKey <- map["accessKey"]
        requestId <- map["requestId"]
        amount <- map["amount"]
        orderId <- map["orderId"]
        orderInfo <- map["orderInfo"]
        signature <- map["signature"]
        extraData <- map["extraData"]
        transId <- map["transId"]
        localMessage <- map["localMessage"]
        errorCode <- map["errorCode"]
        message <- map["message"]
    }
}
