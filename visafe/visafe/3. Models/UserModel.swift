//
//  UserModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class UserModel: NSObject, Mappable {
    var email: String?
    var username: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        username <- map["username"]
    }
}
