//
//  LoginParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class LoginParam: NSObject, Mappable {
    var email: String?
    var password: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        password <- map["password"]
        email <- map["email"]
    }
}
