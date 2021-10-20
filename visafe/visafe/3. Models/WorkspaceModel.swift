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
    
    //intro
    func getImageIntro() -> UIImage? {
        switch self {
        case .family:
            return UIImage(named: "protect_family")
        case .enterprise:
            return UIImage(named: "protect_orgnization")
        case .govermnent:
            return UIImage(named: "protect_orgnization")
        case .school:
            return UIImage(named: "protect_orgnization")
        default:
            return UIImage(named: "protect_orgnization")
        }
    }
    
    func getTitleIntro() -> String? {
        switch self {
        case .family:
            return "Bảo vệ gia đình & nhóm"
        case .enterprise:
            return "Bảo vệ tổ chức"
        case .govermnent:
            return "Bảo vệ tổ chức"
        case .school:
            return "Bảo vệ tổ chức"
        default:
            return "Bảo vệ tổ chức"
        }
    }
    
    func getContentIntro() -> String? {
        return "Tất cả thành viên tham gia nhóm đều được ViSafe bảo vệ trên môi trường mạng"
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
    var local_msg: String?
    
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
        local_msg <- map["local_msg"]
    }
}
