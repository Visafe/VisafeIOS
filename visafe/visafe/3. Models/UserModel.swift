//
//  UserModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class UserModel: NSObject, Mappable {
    var userid: String?
    var email: String?
    var fullname: String?
    var phonenumber: String?
    var isverify: Bool?
    var isActive: Bool?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        userid <- map["UserID"]
        fullname <- map["FullName"]
        email <- map["email"]
        phonenumber <- map["PhoneNumber"]
        isverify <- map["IsVerify"]
        isActive <- map["IsActive"]
    }
}
