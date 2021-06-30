//
//  RegisterParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class RegisterParam: NSObject, Mappable {
    var full_name: String?
    var email: String?
    var password: String?
    var repeat_password: String?
    var phone_number: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        full_name <- map["full_name"]
        password <- map["password"]
        email <- map["email"]
        repeat_password <- map["repeat_password"]
        phone_number <- map["phone_number"]
    }
}
