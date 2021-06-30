//
//  ActiveAccountResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/29/21.
//

import UIKit
import ObjectMapper

public enum ActiveAccountStatus: Int {
    case success = 200
    case inccorectinfo = 3
    case invalidOtp = 2
    
    func getDescription() -> String {
        var message = ""
        switch self {
        case .inccorectinfo:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        case .invalidOtp:
            message = "OTP không chính xác hoặc quá hạn. Vui lòng thử lại"
        case .success:
            message = "Kích hoạt tài khoản thành công"
        }
        return message
    }
}

class ActiveAccountResult: BaseResult {
    
    var status_code: ActiveAccountStatus?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status_code <- map["status_code"]
    }
}
