//
//  GroupModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import ObjectMapper

public enum GroupTypeEnum: String {
    case adult = "adult"
    case elderly = "elderly"
    case children = "children"
    
    func getDescription() -> String {
        switch self {
        case .adult:
            return "Người lớn"
        case .children:
            return "Trẻ em"
        case .elderly:
            return "Người cao tuổi"
        }
    }
    
    static func getAll() -> [GroupTypeEnum] {
        return [.children, .adult, .elderly]
    }
}

class GroupModel: NSObject, Mappable {
    var adblock_enabled: Bool?
    var app_ads: [String]?
    var block_webs: [String]?
    var blocked_services: [String]?
    var bypass_enabled: Bool?
    var gambling_enabled: Bool?
    var game_ads_enabled: Bool?
    var malware_enabled: Bool?
    var name: String?
    var native_tracking: String?
    var object_type: [GroupTypeEnum] = []
    var parental_enabled: Bool?
    var phishing_enabled: Bool?
    var porn_enabled: Bool?
    var safesearch_enabled: Bool?
    var youtuberestrict_enabled: Bool?
    var workspace_id: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        adblock_enabled <- map["adblock_enabled"]
        app_ads <- map["app_ads"]
        block_webs <- map["block_webs"]
        blocked_services <- map["blocked_services"]
        bypass_enabled <- map["bypass_enabled"]
        gambling_enabled <- map["gambling_enabled"]
        game_ads_enabled <- map["game_ads_enabled"]
        malware_enabled <- map["malware_enabled"]
        name <- map["name"]
        native_tracking <- map["native_tracking"]
        object_type <- map["object_type"]
        parental_enabled <- map["parental_enabled"]
        phishing_enabled <- map["phishing_enabled"]
        porn_enabled <- map["porn_enabled"]
        safesearch_enabled <- map["safesearch_enabled"]
        youtuberestrict_enabled <- map["youtuberestrict_enabled"]
        workspace_id <- map["workspace_id"]
    }
}

