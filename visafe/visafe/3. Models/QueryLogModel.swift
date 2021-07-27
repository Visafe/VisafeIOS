//
//  QueryLogModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit
import ObjectMapper

class QueryLogModelQuestion: NSObject, Mappable {
    var cclass: String?
    var host: String?
    var type: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cclass <- map["class"]
        host <- map["host"]
        type <- map["type"]
    }
}


class QueryLogModel: NSObject, Mappable {
    var client: String?
    var client_id: String?
    var client_proto: String?
    var elapsedMs: String?
    var filterId: Int?
    var reason: String?
    var rule: String?
    var time: Date?
    var upstream: String?
    var question: QueryLogModelQuestion?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        client <- map["client"]
        client_id <- map["client_id"]
        client_proto <- map["client_proto"]
        elapsedMs <- map["elapsedMs"]
        filterId <- map["filterId"]
        reason <- map["reason"]
        rule <- map["rule"]
        time <- (map["time"], ViSafeDateFormater())
        upstream <- map["upstream"]
        question <- map["question"]
    }
}
