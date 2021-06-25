//
//  BaseResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

class BaseResult: Mappable {
    
    var isSuccess: Bool?
    var errorMessage: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isSuccess <- map["IsSuccess"]
        errorMessage <- map["ErrorMessage"]
    }
}
