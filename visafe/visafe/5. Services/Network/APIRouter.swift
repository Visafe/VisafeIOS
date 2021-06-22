//
//  APIRouter.swift
//  TripTracker
//
//  Created by quangpc on 7/18/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import Moya


enum APIRouter {
    case login(Void)
}

enum APIError: Error {
    case serverLogicError(message: String)
    case parseError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverLogicError(message: let msg):
            return msg
        default:
            return "There is something wrong with data."
        }
    }
}

enum APIConstant {
    static let baseURL = "http://triptracker.nanoweb.vn"
    static let baseAPIURL = APIConstant.baseURL + "/api/v1"
    static let baseMediaURL = APIConstant.baseURL + "/static"
    
    static func imageURL(path: String, name: String) -> String {
        return baseMediaURL + path + name
    }
}

extension APIRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIConstant.baseAPIURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/user/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .get
        default:
            break
        }
        return .post
    }
    
    var parameters: [String: Any] {
        var pars = [String: Any]()
        switch self {
        case .login:
            break
        }
        return pars
    }
    
    var task: Task {
        switch self {
        case .login:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            break
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String : String]? {
        let hea: [String: String] = ["token": "all08102018_triptracker2018"]
        return hea
    }
    
    private func multipartsFromParameters() -> [MultipartFormData] {
        var forms: [MultipartFormData] = []
        for (key, value) in parameters {
            if value is [Dictionary<String, Any>] {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
                forms.append(MultipartFormData(provider: .data(encodedData), name: key))
            } else {
                let str = "\(value)"
                if let data = str.data(using: .utf8) {
                    forms.append(MultipartFormData(provider: .data(data), name: key))
                }
            }
        }
        return forms
    }
}
