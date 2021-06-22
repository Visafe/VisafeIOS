//
//  APIManager.swift
//  TripTracker
//
//  Created by quangpc on 7/23/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import SwiftyJSON
import SwiftyUserDefaults
class APIManager {
    
    static let shared = APIManager()
    
    let provider = MoyaProvider<APIRouter>(plugins: [NetworkLoggerPlugin()])
    
    @discardableResult
    func request(target: APIRouter, completion: @escaping (_ json: JSON?,_ error: Error?) -> Void) -> Cancellable {
        return provider.request(target, completion: { (result) in
            switch result {
            case .success(let response):
                guard let json = try? JSON(data: response.data) else {
                    let str = String(data: response.data, encoding: .utf8)
                    print(str ?? "none")
                    completion(nil, APIError.parseError)
                    return
                }
                let isError = json["errors"].exists()
                if isError {
                    let message = json["errors"].dictionaryValue
                    var msgString = ""
                    for (key, value) in message {
                        let arr = value.arrayValue
                        let arrString = arr.map { $0.stringValue }.joined(separator: ", ")
                        msgString += key + ": " + arrString + "\n"
                    }
                    completion(nil, APIError.serverLogicError(message: msgString))
                    return
                }
                completion(json["data"], nil)
            case .failure(_):
                completion(nil, APIError.serverLogicError(message: "Something's wrong with server."))
            }
        })
    }
    
    func reLogin(completion:(_ success: Bool) -> Void?) {
        
    }
    
    func requestBool(target: APIRouter, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        request(target: target) { (json, error) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func requestObject<T:JSONModelable>(target: APIRouter, completion: @escaping (_ object: T?, _ error: Error?) -> Void) {
        request(target: target) { (json, error) in
            if let json = json {
                completion(T(json: json), nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestObjects<T:JSONModelable>(target: APIRouter, completion: @escaping (_ object: [T]?, _ error: Error?) -> Void) {
        request(target: target) { (json, error) in
            if let json = json {
                var photos: [T] = []
                var jsonDatas = json.arrayValue
                if let jsons = json["list"].array{
                    jsonDatas = jsons
                }
                for pho in jsonDatas {
                    if let model = T(json: pho) {
                        photos.append(model)
                    }
                }
                completion(photos, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    @discardableResult
    func requestPage(target: APIRouter, completion: @escaping (_ json: JSON?, _ nextPage: Int, _ error: Error?) -> Void) -> Cancellable {
        return provider.request(target, completion: { (result) in
            switch result {
            case .success(let response):
                guard let json = try? JSON(data: response.data) else {
                    let str = String(data: response.data, encoding: .utf8)
                    print(str ?? "none")
                    completion(nil, 0, APIError.parseError)
                    return
                }
                let isError = json["errors"].exists()
                if isError {
                    let message = json["errors"].dictionaryValue
                    var msgString = ""
                    for (key, value) in message {
                        let arr = value.arrayValue
                        let arrString = arr.map { $0.stringValue }.joined(separator: ", ")
                        msgString += key + ": " + arrString + "\n"
                    }
                    completion(nil, 0, APIError.serverLogicError(message: msgString))
                    return
                }
                completion(json["data"], json["next_page"].intValue, nil)
            case .failure(_):
                completion(nil, 0, APIError.serverLogicError(message: "Something's wrong with server."))
            }
        })
    }
}
