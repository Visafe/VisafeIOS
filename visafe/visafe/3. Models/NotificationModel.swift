//
//  NotificationModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit
import ObjectMapper

class NotificationTargetModel: NSObject, Mappable {
    var domain: String?
    var type: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        domain <- map["domain"]
        type <- map["type"]
    }
}

class NotificationDeviceModel: NSObject, Mappable {
    var deviceId: String?
    var name: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        deviceId <- map["deviceId"]
        name <- map["name"]
    }
}

public enum NotificationContentTypeEnum: String {
    case alertDomain = "ALERT_DOMAIN"
    case deviceJoinSuccess = "DEVICE_JOIN_SUCCESS"
    case inviteSuccess = "INVITE_SUCCESS"
    case joinSuccess = "JOIN_SUCCESS"
    case alertTransaction = "ALERT_TRANSACTION"
    case requestOutGroup = "REQUEST_OUT_GROUP"
}

class NotificationContentModel: NSObject, Mappable {
    
    var affected: NotificationDeviceModel?
    var type: NotificationContentTypeEnum?
    var target: NotificationTargetModel?
    var duration: String?
    var package_name: String?
    var status_payment: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        affected <- map["affected"]
        type <- map["type"]
        target <- map["target"]
        duration <- map["duration"]
        package_name <- map["package_name"]
        status_payment <- map["status_payment"]
    }
}


class NotificationModel: NSObject, Mappable {
    var isRead: Bool?
    var isSee: Bool?
    var id: Int?
    var createdAt: String?
    var group: GroupModel?
    var content: NotificationContentModel?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        isRead <- map["isRead"]
        isSee <- map["isSee"]
        id <- map["id"]
        createdAt <- map["createdAt"]
        group <- map["group"]
        content <- map["content"]
    }
    
    func buildContent() -> String {
        switch (content?.type ?? .alertDomain) {
        case .alertDomain:
            return "Thiết bị \(content?.affected?.name ?? "") đã cố gắng truy cập vào trang web: \(content?.target?.domain ?? "")"
        case .deviceJoinSuccess:
            return "Thiết bị \(content?.affected?.name ?? "") vừa được thêm vào nhóm: \(group?.name ?? "")"
        case .joinSuccess:
            return "Bạn đã là thành viên của nhóm: \(group?.name ?? "")"
        case .inviteSuccess:
            return " \(content?.affected?.name ?? "") đã là thành viên của nhóm: \(group?.name ?? "")"
        case .alertTransaction:
            if content?.status_payment == "0" {
                return "Bạn đã giao dịch thành công gói \(content?.package_name ?? "") trong thời gian \(content?.duration ?? "") tháng"
            } else {
                return "Giao dịch thất bại gói \(content?.package_name ?? "") trong thời gian \(content?.duration ?? "") tháng"
            }
        case .requestOutGroup:
            return "Thiết bị \(content?.affected?.name ?? "") yêu cầu rời khỏi nhóm \(group?.name ?? "")"
        }
    }
    
    func buildTime() -> String {
        return Date(timeIntervalSince1970: TimeInterval(createdAt?.int ?? 0)).getTimeOnFeed()
    }
}
