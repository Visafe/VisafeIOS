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

class NotificationContentModel: NSObject, Mappable {
    
    var affected: NotificationDeviceModel?
    var type: String?
    var target: NotificationTargetModel?
    
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
}
