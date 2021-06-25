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

enum APIRouter {
    case login(param: LoginParam)
    case register(param: RegisterParam)
    case forgotPassword(email: String?)
    case resetPassword(param: ResetPassParam)
    case changePassword(param: ChangePassParam)
    case changeProfile(param: UserModel)
    case reactivation
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
    static let baseURL = "http://staging.visafe.vn"
}

extension APIRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/control/login"
        case .register:
            return "/control/register"
        case .forgotPassword:
            return "/control/forgot-password"
        case .resetPassword:
            return "/control/reset-password"
        case .changePassword:
            return "/control/change_password"
        case .changeProfile:
            return "/control/change_profile"
        case .reactivation:
            return "/re-activation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forgotPassword:
            return .get
        default:
            break
        }
        return .post
    }
    
    var parameters: [String: Any] {
        var pars = [String: Any]()
        switch self {
        case .login(param: let param):
            pars = param.toJSON()
        case .register(param: let param):
            pars = param.toJSON()
        case .forgotPassword(email: let email):
            pars["email"] = email
        case .resetPassword(param: let param):
            pars = param.toJSON()
        case .changePassword(param: let param):
            pars = param.toJSON()
        case .changeProfile(param: let param):
            pars = param.toJSON()
        case .reactivation:
            break
            
        }
        return pars
    }
    
    var task: Task {
        switch self {
        case .register, .login, .resetPassword, .changePassword, .changeProfile, .reactivation:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default:
            break
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String : String]? {
        let hea: [String: String] = [:]
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
