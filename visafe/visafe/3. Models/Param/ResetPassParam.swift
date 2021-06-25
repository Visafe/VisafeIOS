//
//  ResetPassParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class ResetPassParam: NSObject, Mappable {
    var email: String?
    var otp: String?
    var password: String?
    var repeat_password: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        password <- map["password"]
        email <- map["email"]
        otp <- map["otp"]
        repeat_password <- map["repeat_password"]
    }
}
