//
//  WorkspaceWorker.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class WorkspaceWorker {
    static func getList(completion: @escaping (_ result: [WorkspaceModel]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.getListWorkspace
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: [WorkspaceModel]?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<WorkspaceModel>().mapArray(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func add(workspace: WorkspaceModel, completion: @escaping (_ result: WorkspaceModel?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.addWorkspace(param: workspace)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: WorkspaceModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<WorkspaceModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func update(workspace: WorkspaceModel, completion: @escaping (_ result: WorkspaceModel?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.updateWorkspace(param: workspace)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: WorkspaceModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<WorkspaceModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func delete(wspId: String?, completion: @escaping (_ result: BaseResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.deleteWorkspace(wspId: wspId)
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
    
    static func updateName(param: WorkspaceUpdateNameParam, completion: @escaping (_ result: WorkspaceModel?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.updateNameWorkspace(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: WorkspaceModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<WorkspaceModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func getStatistic(wspId: String, limit: Int, completion: @escaping (_ result: StatisticModel?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.statisticWorkspace(id: wspId, limit: limit)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: StatisticModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<StatisticModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
    
    static func getLog(param: QueryLogParam, completion: @escaping (_ result: QueryLogResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.logWorkspace(param: param)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var loginResult: QueryLogResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<QueryLogResult>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error, statusCode)
        }
    }
}
