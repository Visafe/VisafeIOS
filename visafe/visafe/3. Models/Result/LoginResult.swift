//
//  LoginResult.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/26/21.
//

import UIKit
import ObjectMapper

public enum LoginStatusEnum: Int {
    case unactiveAccount = 1
    case unauthen = 0
    case error = 500
    
    func getDescription() -> String {
        var message = ""
        switch self {
        case .unactiveAccount:
            message = "Vui lòng kích hoạt tài khoản của bạn"
        case .unauthen:
            message = "Email hoặc mật khẩu không chính xác"
        case .error:
            message = "Có lỗi xảy ra. Vui lòng thử lại."
        }
        return message
    }
}

public enum ResiterStatusEnum: Int {
    case alreadylogin = 400
    case invalidate = 401
    case empty = 403
    case emailExist = 409
    case error = 500
    case passwordweak = 2
    case unactiveAccount = 1
    
    func getDescription() -> String {
        var message = ""
        switch self {
        case .alreadylogin:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        case .passwordweak:
            message = "Mật khẩu không đủ mạnh. Vui lòng nhập cả chữ và số"
        case .emailExist:
            message = "Địa chỉ email đã được sử dụng. Vui lòng sử dụng email khác"
        case .invalidate:
            message = "Email và password không hợp lệ. Vui lòng kiểm tra lại"
        case .error:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        case .empty:
            message = "Email và password không được để trống. Vui lòng kiểm tra lại"
        case .unactiveAccount:
            message = "Vui lòng kích hoạt tài khoản của bạn"
        }
        return message
    }
}

class LoginResult: BaseResult {
    
    var token: String?
    var status_code: LoginStatusEnum?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        token <- map["token"]
        status_code <- map["status_code"]
    }
}

class ResgisterResult: BaseResult {
    
    var token: String?
    var status_code: ResiterStatusEnum?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        token <- map["token"]
        status_code <- map["status_code"]
    }
}
