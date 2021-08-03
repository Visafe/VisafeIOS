//
//  StatisticModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/22/21.
//

import UIKit
import ObjectMapper

public enum StatisticCategoryAppEnum: String {
    case zalo = "zalo"
    case facebook = "facebook"
    case twitter = "twitter"
    case instagram = "instagram"
    case ok = "ok"
    case vk = "vk"
    case reddit = "reddit"
    case tiktok = "tiktok"
    case _9gag = "9gag"
    case weibo = "weibo"
    case epicgames = "epicgames"
    case steam = "steam"
    case origin = "origin"
    case blizzard = "blizzard"
    case leagueoflegends = "leagueoflegends"
    case minecraft = "minecraft"
    case netflix = "netflix"
    case hulu = "hulu"
    case disneyplus = "disneyplus"
    case primevideo = "primevideo"
    case fptplay = "fptplay"
    case galaxyplay = "galaxyplay"
    case tinder = "tinder"
    case discord = "discord"
    case viber = "viber"
    case wechat = "wechat"
    case snapchat = "snapchat"
    case whatsapp = "whatsapp"
    case telegram = "telegram"
    case skype = "skype"
    case messenger = "messenger"
    case vimeo = "vimeo"
    case dailymotion = "dailymotion"
    case youtube = "youtube"
    case twitch = "twitch"
    case spotify = "spotify"
    case nhaccuatui = "nhaccuatui"
    case zingmp3 = "zingmp3"
    case soundcloud = "soundcloud"
    case ebay = "ebay"
    case amazon = "amazon"
    case tiki = "tiki"
    case lazada = "lazada"
    case shopee = "shopee"
    
    func getTitle() -> String {
        return self.rawValue.firstUppercased
    }
    
    func getIcon() -> UIImage? {
        return UIImage(named: "ic_app_\(self.rawValue)")
    }
}

public enum StatisticCategoryEnum: String {
    case social_network = "social_network"
    case game = "game"
    case movie = "movie"
    case dating = "dating"
    case messaging = "messaging"
    case video = "video"
    case music = "music"
    case shopping = "shopping"
    
    func getTitle() -> String {
        switch self {
        case .social_network:
            return "Mạng xã hội"
        case .game:
            return "Trò chơi"
        case .movie:
            return "Phim ảnh"
        case .dating:
            return "Hẹn hò"
        case .messaging:
            return "Nhắn tin"
        case .video:
            return "Video"
        case .music:
            return "Âm nhạc"
        case .shopping:
            return "Mua sắm"
        }
    }
    
    func getIcon() -> UIImage? {
        return UIImage(named: "ic_category_\(self.rawValue)")
    }
}

class StatisticCategoryApp: NSObject, Mappable {
    var count: CFloat = 0
    var name: StatisticCategoryAppEnum?
    
    // Thêm tỉ lệ phần trăm để hiển thị
    var percent: CFloat = 0
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        name <- map["name"]
    }
}

class StatisticCategory: NSObject, Mappable {
    var apps: [StatisticCategoryApp]?
    var count: CFloat = 0
    var name: StatisticCategoryEnum?
    
    // Thêm tỉ lệ phần trăm để hiển thị
    var percent: CFloat = 0
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        apps <- map["apps"]
        count <- map["count"]
        name <- map["name"]
    }
}

class StatisticModel: NSObject, Mappable {
    var time_units: String?
    var num_dns_queries: Int = 0
    var num_dangerous_domain: Int = 0
    var num_native_tracking: Int = 0
    var num_violation: Int = 0
    var num_ads_blocked: Int = 0
    var num_dangerous_domain_all: Int = 0
    var num_ads_blocked_all: Int = 0
    var num_violation_all: Int = 0
    var num_native_tracking_all: Int = 0
    var top_categories: [StatisticCategory]?
    var num_access_blocked: Int = 0
    var num_content_blocked: Int = 0
    var num_access_blocked_all: Int = 0
    var num_content_blocked_all: Int = 0
    
    var timeType: ChooseTimeEnum = .day
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        time_units <- map["time_units"]
        num_dns_queries <- map["num_dns_queries"]
        num_dangerous_domain <- map["num_dangerous_domain"]
        num_violation <- map["num_violation"]
        num_native_tracking <- map["num_native_tracking"]
        num_ads_blocked_all <- map["num_ads_blocked_all"]
        num_dangerous_domain_all <- map["num_dangerous_domain_all"]
        num_violation_all <- map["num_violation_all"]
        num_ads_blocked <- map["num_ads_blocked"]
        num_access_blocked <- map["num_access_blocked"]
        num_content_blocked <- map["num_content_blocked"]
        num_access_blocked_all <- map["num_access_blocked_all"]
        num_content_blocked_all <- map["num_content_blocked_all"]
        top_categories <- map["top_categories"]
    }
}
