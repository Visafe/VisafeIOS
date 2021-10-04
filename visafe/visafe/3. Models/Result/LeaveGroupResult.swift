//
//  LeaveGroupResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 10/2/21.
//

import Foundation
import ObjectMapper

class LeaveGroupResult: Mappable {

    var status_code: Int?
    var responseCode: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status_code <- map["status_code"]
    }
}
