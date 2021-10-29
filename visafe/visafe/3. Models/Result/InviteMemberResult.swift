//
//  InviteMemberResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/1/21.
//

import UIKit
import ObjectMapper

public enum InviteMemberStatus: Int {
    case defaultStatus = 1
    case invalite = 2
    
    func getDescription() -> String {
        var message = "Có lỗi xảy ra. Vui lòng thử lại"
        switch self {
        case .invalite:
            message = "Người dùng không tồn tại. Vui lòng thử lại"
        default:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        }
        return message
    }
}

class InviteMemberResult: BaseResult {
    
    var status_code: InviteMemberStatus?
    var invited: [UserModel]?
    var invited_sent_mail: [UserModel]?
    var phone_out_sys: [UserModel]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        invited <- map["invited"]
        invited_sent_mail <- map["invited_sent_mail"]
        phone_out_sys <- map["phone_out_sys"]
        status_code <- map["status_code"]
    }
}
