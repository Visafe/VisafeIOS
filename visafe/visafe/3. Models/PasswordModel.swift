//
//  PasswordModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import ObjectMapper

class PasswordModel: NSObject, Mappable {
    var email: String?
    var password: String?
    var phone_number: String?
    var otp: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        otp <- map["otp"]
        phone_number <- map["phone_number"]
    }
}
