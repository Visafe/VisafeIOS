//
//  ForgotPasswordResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import ObjectMapper

public enum ForgotPasswordStatus: Int {
    case cantsendemail = 424
    case invalidateEmail = 1
    case error = 500
    case sendThroughEmail = 2
    
    func getDescription() -> String {
        var message = ""
        switch self {
        case .error:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        case .invalidateEmail:
            message = "Email không hợp lệ. Vui lòng kiểm tra lại"
        case .cantsendemail:
            message = "Không thể gửi email. Vui lòng thử lại"
        case .sendThroughEmail:
            message = "Gửi OTP thành công. Vui lòng kiểm tra email để lấy mã"
        }
        return message
    }
}

class ForgotPasswordResult: BaseResult {
    
    var status_code: ForgotPasswordStatus?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status_code <- map["status_code"]
    }
}
