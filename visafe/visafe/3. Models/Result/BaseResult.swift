//
//  BaseResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class BaseResult: Mappable {
    
    var msg: String?
    var responseCode: Int?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        msg <- map["msg"]
    }
}
