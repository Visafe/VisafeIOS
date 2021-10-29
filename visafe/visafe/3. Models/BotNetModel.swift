//
//  BotNetModel.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 12/08/2021.
//

import UIKit
import ObjectMapper

class BotNetModel: NSObject, Mappable {
    var src_ip: String?
    var isp: String?
    var os: String?
    var browsers: Bool?
    var anonymizer: Bool?
    var lastseen: Date?
    var isBotnet: String?
    var detail: [BotNetDetailModel]?

    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        src_ip <- map["src_ip"]
        isp <- map["isp"]
        os <- map["os"]
        browsers <- map["browsers"]
        anonymizer <- map["anonymizer"]
        lastseen <- (map["lastseen"], ViSafeDateFormater())
        isBotnet <- map["isBotnet"]
        detail <- map["detail"]
    }
}

class BotNetDetailModel: NSObject, Mappable {
    var cc_ip: String?
    var mw_type: String?
    var cc_port: String?
    var lastseen: Date?

    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        cc_ip <- map["cc_ip"]
        mw_type <- map["mw_type"]
        cc_port <- map["cc_port"]
        lastseen <- (map["lastseen"], ViSafeDateFormater())
    }

    func getDomain() -> String {
        return (mw_type ?? "") + " - " + (cc_ip ?? "") + ":\(cc_port ?? "")"
    }
}
