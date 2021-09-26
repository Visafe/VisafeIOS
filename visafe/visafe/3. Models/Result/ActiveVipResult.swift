//
//  ActiveVipResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 9/26/21.
//

import Foundation
import ObjectMapper

class ActiveVipResult: Mappable {

    var status_code: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status_code <- map["status_code"]
    }
}
