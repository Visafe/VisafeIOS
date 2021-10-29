//
//  ResetPasswordResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import ObjectMapper
import UIKit

public enum ResetPasswordStatus: Int {
    case error = 0
    case invalidPass = 3
    case invalidOtp = 2
    
    func getDescription() -> String {
        var message = ""
        switch self {
        case .error:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        case .invalidPass:
            message = "Mật khẩu không đủ mạnh. Vui lòng nhập cả chữ và số"
        case .invalidOtp:
            message = "OTP không chính xác. Vui lòng thử lại"
        }
        return message
    }
}

class ResetPasswordResult: BaseResult {
    
    var status_code: ResetPasswordStatus?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status_code <- map["status_code"]
    }
}
