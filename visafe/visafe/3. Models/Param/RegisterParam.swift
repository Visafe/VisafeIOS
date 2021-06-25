//
//  RegisterParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class RegisterParam: NSObject, Mappable {
    var username: String?
    var email: String?
    var password: String?
    var passwordagain: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
        email <- map["email"]
        passwordagain <- map["passwordagain"]
    }
}
