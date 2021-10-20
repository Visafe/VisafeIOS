//
//  LeaveGroupResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 10/2/21.
//

import Foundation
import ObjectMapper

class LeaveGroupResult: BaseResult {

    var status_code: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status_code <- map["status_code"]
    }
}
