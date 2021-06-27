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
    static func getList(completion: @escaping (_ result: [WorkspaceModel]?, _ error: Error?) -> Void) {
        let router = APIRouter.getListWorkspace
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: [WorkspaceModel]?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<WorkspaceModel>().mapArray(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func add(workspace: WorkspaceModel, completion: @escaping (_ result: WorkspaceModel?, _ error: Error?) -> Void) {
        let router = APIRouter.addWorkspace(param: workspace)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: WorkspaceModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<WorkspaceModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func update(workspace: WorkspaceModel, completion: @escaping (_ result: WorkspaceModel?, _ error: Error?) -> Void) {
        let router = APIRouter.updateWorkspace(param: workspace)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: WorkspaceModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<WorkspaceModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func delete(wspId: String?, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.deleteWorkspace(wspId: wspId)
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
