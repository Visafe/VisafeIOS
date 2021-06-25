//
//  AuthenWorker.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class AuthenWorker {
    
    static func register(param: RegisterParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.register(param: param)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func login(param: LoginParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.login(param: param)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func forgotPassword(email: String?, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.forgotPassword(email: email)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func resetPassword(param: ResetPassParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.resetPassword(param: param)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func changePassword(param: ChangePassParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.changePassword(param: param)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func changeProfile(param: UserModel, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.changeProfile(param: param)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func reactivation(completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.reactivation
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
}
