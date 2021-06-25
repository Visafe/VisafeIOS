//
//  ChangePassParam.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class ChangePassParam: NSObject, Mappable {
    var currentPassword: String?
    var newPassword: String?
    var repeatPassword: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        currentPassword <- map["currentPassword"]
        newPassword <- map["newPassword"]
        repeatPassword <- map["repeatPassword"]
    }
}
