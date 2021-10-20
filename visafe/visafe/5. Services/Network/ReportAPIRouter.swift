//
//  APIRouter.swift
//  TripTracker
//
//  Created by quangpc on 7/18/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import ObjectMapper

enum ReportAPIRouter {

    // báo cáo web
    case reportPhishing(url: String)
}

enum APIConstant {
    static let baseURL = "https://app.visafe.vn/api/v1"
//    static let baseURL = "https://staging.visafe.vn/api/v1"
}

enum APIError: Error {
    case serverLogicError(message: String)
    case parseError
}

extension ReportAPIRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }

    var path: String {
        return "/report_phishing"
    }

    var method: Moya.Method {
        return .post
    }

    var parameters: [String: Any] {
        var pars = [String: Any]()
        switch self {
        case .reportPhishing(url: let url):
            pars["url"] = url
        }
        return pars
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var headers: [String : String]? {
        var hea: [String: String] = [:]
        return hea
    }
}
