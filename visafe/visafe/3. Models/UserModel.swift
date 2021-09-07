//
//  UserModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import ObjectMapper

public enum GroupMemberRoleEnum: Int {
    case owner = 1
    case admin = 2
    case suppervisor = 3
    case member = 4
    
    func getTitle() -> String {
        switch self {
        case .owner:
            return "Chủ nhóm"
        case .admin:
            return "Quản trị viên"
        case .suppervisor:
            return "Giám sát viên"
        default:
            return "Thành viên"
        }
    }
}

public enum AccountTypeEnum: String {
    case standard = "ACCOUNT_STANDARD"
    case facebook = "ACCOUNT_FACEBOOK"
    case google = "ACCOUNT_GOOGLE"
    case apple = "ACCOUNT_APPLE"
}

class UserModel: NSObject, Mappable {
    var userid: Int?
    var email: String?
    var fullname: String?
    var phonenumber: String?
    var isverify: Bool?
    var isActive: Bool?
    var role: GroupMemberRoleEnum = .member
    var defaultGroup: String?
    var defaultWorkspace: String?
    var accountType: PakageNameEnum = .personal
    var timeStart: String?
    var timeEnd: String?
    var maxWorkspace: Int = 0
    var maxGroup: Int = 0
    var maxDevice: Int = 0
    var userIDString: String?
    var typeRegister: AccountTypeEnum?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        userIDString <- map["UserID"]
        userid <- map["UserID"]
        if userid == nil {
            userid = userIDString?.int
        }
        fullname <- map["FullName"]
        email <- map["email"]
        phonenumber <- map["PhoneNumber"]
        isverify <- map["IsVerify"]
        isActive <- map["IsActive"]
        defaultGroup <- map["DefaultGroup"]
        defaultWorkspace <- map["DefaultWorkspace"]
        accountType <- map["AccountType"]
        timeStart <- map["TimeStart"]
        timeEnd <- map["TimeEnd"]
        maxWorkspace <- map["MaxWorkspace"]
        maxGroup <- map["MaxGroup"]
        maxDevice <- map["MaxDevice"]
        typeRegister <- map["TypeRegister"]
    }
}
