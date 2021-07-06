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
            message = "Tên đăng nhập hoặc mật khẩu không chính xác"
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
    case usernamenotempty = 3
    case invalidpassword = 6
    case phoneexists = 4
    case successWithEmail = 1
    case successWithPhone = 0
    case strengthInvalid = 5
    
    func getDescription() -> String {
        var message = ""
        switch self {
        case .alreadylogin:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        case .passwordweak:
            message = "Mật khẩu không đủ mạnh. Vui lòng nhập cả chữ và số"
        case .emailExist:
            message = "Tên đăng nhập đã được sử dụng. Vui lòng sử dụng email khác"
        case .invalidate:
            message = "Tên đăng nhập và password không hợp lệ. Vui lòng kiểm tra lại"
        case .error:
            message = "Có lỗi xảy ra. Vui lòng thử lại"
        case .empty:
            message = "Tên đăng nhập và password không được để trống. Vui lòng kiểm tra lại"
        case .usernamenotempty:
            message = "Tên người dùng không được để trống"
        case .invalidpassword:
            message = "Mật khẩu không hợp lệ"
        case .phoneexists:
            message = "Tên đăng nhập đã được sử dụng"
        case .strengthInvalid:
            message = "Mật khẩu quá ngắn. Vui lòng kiểm tra lại"
        case .successWithEmail, .successWithPhone:
            message = "Đăng ký thành công"
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
