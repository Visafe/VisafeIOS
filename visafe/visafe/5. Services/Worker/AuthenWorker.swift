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
    
    static func register(param: RegisterParam, completion: @escaping (_ result: ResgisterResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.register(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: ResgisterResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<ResgisterResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func loginGoogle(token: String?, completion: @escaping (_ result: LoginResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.loginGoogle(token: token)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: LoginResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<LoginResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func loginFacebook(token: String?, completion: @escaping (_ result: LoginResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.loginFacebook(token: token)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: LoginResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<LoginResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func loginApple(token: String?, completion: @escaping (_ result: LoginResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.loginApple(token: token)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: LoginResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<LoginResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func login(param: LoginParam, completion: @escaping (_ result: LoginResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.login(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: LoginResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<LoginResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func forgotPassword(username: String?, completion: @escaping (_ result: ForgotPasswordResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.forgotPassword(username: username)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: ForgotPasswordResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<ForgotPasswordResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func resetPassword(param: ResetPassParam, completion: @escaping (_ result: ResetPasswordResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.resetPassword(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: ResetPasswordResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<ResetPasswordResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func changePassword(param: ChangePassParam, completion: @escaping (_ result: ChangePasswordResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.changePassword(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: ChangePasswordResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<ChangePasswordResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func changeProfile(param: UserModel, completion: @escaping (_ result: BaseResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.changeProfile(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func reactivation(completion: @escaping (_ result: BaseResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.reactivation
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func profile(completion: @escaping (_ result: UserModel?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.profile
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: UserModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<UserModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func activeAccount(param: PasswordModel, completion: @escaping (_ result: ActiveAccountResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let p = ActiveAccountParam()
        p.username = param.email ?? param.phone_number
        p.otp = param.otp
        let router = APIRouter.activeAccount(param: p)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: ActiveAccountResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<ActiveAccountResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func changeUserProfile(param: ChangeProfileParam, completion: @escaping (_ result: BaseResult?, _ error: Error?, _ statusCode: Int? ) -> Void) {
        let router = APIRouter.changeUseProfile(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            let result = BaseResult()
            result.responseCode = statusCode
            completion(result, error, statusCode)
        }
    }
}
