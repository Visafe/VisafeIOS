//
//  ChangePasswordResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit
import ObjectMapper

public enum ChangePasswordStatus: Int {
    case passwordsort = 2
    case passwordnotmatch = 1
    case currentpassincorect = 3
    
    func getDescription() -> String {
        var message = "Có lỗi xảy ra. Vui lòng thử lại"
        switch self {
        case .passwordnotmatch:
            message = "Mật khẩu mới không trùng nhau"
        case .passwordsort:
            message = "Mật khẩu phải có độ dài từ 8 đến 32 ký tự "
        case .currentpassincorect:
            message = "Mật khẩu hiện tại không đúng"
        }
        return message
    }
}

class ChangePasswordResult: BaseResult {
    
    var status_code: ChangePasswordStatus?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status_code <- map["status_code"]
    }
}
