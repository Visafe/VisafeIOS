//
//  InviteDeviceResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/3/21.
//

import UIKit
import ObjectMapper

public enum InviteDeviceStatus: Int {
    case defaultStatus = 1
    case success = 200
    
    func getDescription() -> String {
        var message = "Có lỗi xảy ra. Vui lòng thử lại"
        switch self {
        case .success:
            message = "Thiết bị đã được thêm vào nhóm"
        default:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        }
        return message
    }
}

class InviteDeviceResult: BaseResult {
    
    var status_code: InviteDeviceStatus?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status_code <- map["status_code"]
    }
}
