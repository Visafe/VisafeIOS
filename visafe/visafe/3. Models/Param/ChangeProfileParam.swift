//
//  ChangeProfileParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 10/5/21.
//

import Foundation
import ObjectMapper

class ChangeProfileParam: NSObject, Mappable {
    
    var full_name: String?
    var email: String?
    var phone_number: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        full_name <- map["full_name"]
        email <- map["email"]
        phone_number <- map["phone_number"]
    }
}
