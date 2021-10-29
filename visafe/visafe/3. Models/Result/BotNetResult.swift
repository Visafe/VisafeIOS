//
//  BotNetResult.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 12/08/2021.
//

import Foundation
import ObjectMapper

class BotNetResult: Mappable {

    var result: BotNetModel?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        result <- map["msg"]
    }
}
