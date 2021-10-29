//
//  QueryLogResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit
import ObjectMapper

class QueryLogResult: BaseResult {
    
    var data: [QueryLogModel]?
    var oldest: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
        oldest <- map["oldest"]
    }
}
