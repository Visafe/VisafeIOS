//
//  WorkspaceModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit
import ObjectMapper

public enum WorkspaceTypeEnum: String {
    case personal = "PERSONAL"
    case family = "FAMILY"
    case school = "SCHOOL"
    case govermnent = "GOVERNMENT_ORGANIZATION"
    case enterprise = "ENTERPRISE"
    
    func getIcon() -> UIImage? {
        switch self {
        case .family:
            return UIImage(named: "wsp_family")
        case .enterprise:
            return UIImage(named: "wsp_enterprise")
        case .govermnent:
            return UIImage(named: "wsp_goverment")
        case .school:
            return UIImage(named: "wsp_edu")
        default:
            return UIImage(named: "wsp_person")
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .family:
            return "Gia đình"
        case .enterprise:
            return "Doanh nghiệp"
        case .govermnent:
            return "Tổ chức chính phủ"
        case .school:
            return "Trường học"
        default:
            return "Cá nhân"
        }
    }
    
    static func getAll() -> [WorkspaceTypeEnum] {
        return [.personal, .family, .school, .enterprise, .govermnent]
    }
}

class WorkspaceModel: NSObject, Mappable {
    var id: String?
    var name: String?
    var isActive: Bool?
    var type: WorkspaceTypeEnum?
    var userOwner: Int?
    var isOwner: Bool?
    var phishingEnabled: Bool?
    var malwareEnabled: Bool?
    var logEnabled: Bool?
    var groupIds: [String]?
    var members: [String]?
    var createdAt: String?
    var updatedAt: String?
    
    override init() {
        super.init()
    }

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        isActive <- map["isActive"]
        type <- map["type"]
        userOwner <- map["userOwner"]
        isOwner <- map["isOwner"]
        phishingEnabled <- map["phishingEnabled"]
        malwareEnabled <- map["malwareEnabled"]
        logEnabled <- map["logEnabled"]
        groupIds <- map["groupIds"]
        members <- map["members"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
    }
}
