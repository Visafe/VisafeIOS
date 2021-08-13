//
//  PackageModel.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/12/21.
//

import UIKit
import ObjectMapper

public enum PakageNameEnum: String {
    case personal = "PERSONAL"
    case family = "FAMILY"
    case premium = "PREMIUM"
    case business = "BUSINESS"
    
    func getIndex() -> Int {
        switch self {
        case .personal:
            return 0
        case .premium:
            return 1
        case .family:
            return 2
        case .business:
            return 3
        }
    }
    
    func getNextPackage() -> PakageNameEnum {
        switch self {
        case .personal:
            return .premium
        case .premium:
            return .family
        case .family:
            return .business
        case .business:
            return .business
        }
    }
    
    func getLogo() -> UIImage? {
        switch self {
        case .premium:
            return UIImage(named: "ic_license_premium")
        case .family:
            return UIImage(named: "ic_license_family")
        case .business:
            return UIImage(named: "ic_license_business")
        case .personal:
            return UIImage(named: "ic_basic")
        }
    }
    
    func getDesciption() -> String? {
        switch self {
        case .premium:
            return "Nâng cấp lên phiên bản Premium cho phép bạn truy cập không giới hạn tính năng của ứng dụng"
        case .family:
            return "Nâng cấp lên phiên bản Family cho phép bạn bảo vệ mọi thiết bị của thành viên trong gia đình"
        case .business:
            return "Nâng cấp lên phiên bản Business cho phép bạn quản lý và bảo vệ mọi thiết bị của thành viên trong công ty"
        case .personal:
            return nil
        }
    }
}

class PackageModel: NSObject, Mappable {
    var id: Int?
    var name: PakageNameEnum?
    var max_workspace: Int = 0
    var max_device: Int = 0
    var max_group: Int = 0
    var prices: [PackagePriceModel] = []
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        max_workspace <- map["max_workspace"]
        max_device <- map["max_device"]
        prices <- map["prices"]
        max_group <- map["max_group"]
    }
}

class PackagePriceModel: NSObject, Mappable {
    var id: Int?
    var duration: Int = 0
    var day_trail: Int = 0
    var price: Int = 0
    var isBusiness: Bool = false
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        duration <- map["duration"]
        day_trail <- map["day_trail"]
        price <- map["price"]
    }
    
    static func getPriceBusiness() -> PackagePriceModel {
        let model = PackagePriceModel()
        model.isBusiness = true
        return model
    }
}
