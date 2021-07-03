//
//  ListGroupResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/2/21.
//

import UIKit
import ObjectMapper

class ListGroupResult: Mappable {
    
    var clients: [GroupModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        clients <- map["clients"]
    }
}

