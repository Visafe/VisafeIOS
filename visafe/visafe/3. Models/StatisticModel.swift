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
    var count: Float = 0
    var name: StatisticCategoryAppEnum?
    
    // Thêm tỉ lệ phần trăm để hiển thị
    var percent: Int = 0
    
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
    var count: Float = 0
    var name: StatisticCategoryEnum?
    
    // Thêm tỉ lệ phần trăm để hiển thị
    var percent: Int = 0
    
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
    var num_dns_queries: Int?
    var num_blocked_filtering: Int?
    var num_replaced_safebrowsing: Int?
    var num_replaced_safesearch: Int?
    var num_replaced_parental: Int?
    var num_dangerous_domain: Int?
    var num_violation: Int?
    var num_ads_blocked: Int?
    var avg_processing_time: Int?
    var top_categories: [StatisticCategory]?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        time_units <- map["time_units"]
        num_dns_queries <- map["num_dns_queries"]
        num_blocked_filtering <- map["num_blocked_filtering"]
        num_replaced_safebrowsing <- map["num_replaced_safebrowsing"]
        num_replaced_safesearch <- map["num_replaced_safesearch"]
        num_replaced_parental <- map["num_replaced_parental"]
        num_dangerous_domain <- map["num_dangerous_domain"]
        num_violation <- map["num_violation"]
        num_ads_blocked <- map["num_ads_blocked"]
        avg_processing_time <- map["avg_processing_time"]
        top_categories <- map["top_categories"]
    }
}
