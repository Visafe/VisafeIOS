//
//  ActiveVipResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 9/26/21.
//

import Foundation
import ObjectMapper

class ActiveVipResult: BaseResult {

    var status_code: Int?
    var key_info: ActiveVipKeyInfoResult?

    override func mapping(map: Map) {
        super.mapping(map: map)
        status_code <- map["status_code"]
        key_info <- map["key_info"]
    }
}

class ActiveVipKeyInfoResult: Mappable {

    var IsActive: Bool?
    var DOHurl: String?
    var Expired: String?
    var Key: String?
    var CreatedAt: String?
    var ActiveNum: Int?
    var DeviceIds: [String]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        IsActive <- map["IsActive"]
        DOHurl <- map["DOHurl"]
        Expired <- map["Expired"]
        Key <- map["Key"]
        CreatedAt <- map["CreatedAt"]
        ActiveNum <- map["ActiveNum"]
        DeviceIds <- map["DeviceIds"]
    }
}
