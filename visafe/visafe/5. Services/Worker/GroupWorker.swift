//
//  GroupWorker.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class GroupWorker {
    
    static func add(group: GroupModel, completion: @escaping (_ result: GroupModel?, _ error: Error?) -> Void) {
        let router = APIRouter.addGroup(param: group)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: GroupModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<GroupModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func update(group: GroupModel, completion: @escaping (_ result: GroupModel?, _ error: Error?) -> Void) {
        let router = APIRouter.updateGroup(param: group)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: GroupModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<GroupModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
    
    static func rename(param: RenameGroupParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.updateNameGroup(param: param)
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
    
    static func list(wsid: String?, completion: @escaping (_ result: ListGroupResult?, _ error: Error?) -> Void) {
        let router = APIRouter.getGroups(wspId: wsid ?? "")
        APIManager.shared.request(target: router) { (data, error) in
            var result: ListGroupResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<ListGroupResult>().map(JSONObject: json)
                } catch { }
            }
            completion(result, error)
        }
    }
    
    static func delete(groupId: String, userId: Int, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.deleteGroup(groupId: groupId, fkUserId: userId)
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
    
    static func addDevice(param: AddDeviceToGroupParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.addDeviceGroup(param: param)
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
    
    static func deleteDevice(param: DeleteDeviceToGroupParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.deleteDeviceGroup(param: param)
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
    
    static func createIdentifier(name: String, groupId: String, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.createIdentifier(name: name, groupId: groupId)
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
    
    static func updateIdentifier(name: String, groupId: String, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.updateIdentifier(name: name, groupId: groupId)
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
    
    static func deleteIdentifier(id: String, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.deleteIdentifier(id: id)
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
    
    static func getIdentifier(id: String, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.getIdentifier(id: id)
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
    
    static func addDeviceToIdentifier(param: AddDeviceToIdentifierParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.addDeviceToIden(param: param)
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
    
    static func deleteDeviceToIdentifier(param: DeleteDeviceToIdentifierParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.deleteDeviceToIden(param: param)
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
    
    static func inviteToGroup(param: InviteToGroupParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.inviteToGroup(param: param)
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
    
    static func deleteToGroup(param: DeleteToGroupParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.deleteGroupMember(param: param)
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
    
    static func changeManagerPermision(param: ChangeManagerPermisionParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.changeManagerPermision(param: param)
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
    
    static func changeViewerPermision(param: ChangeViewerPermisionParam, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.changeViewerPermision(param: param)
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
    
    static func getStatistic(grId: String, limit: Int, completion: @escaping (_ result: StatisticModel?, _ error: Error?) -> Void) {
        let router = APIRouter.statisticGroup(id: grId, limit: limit)
        APIManager.shared.request(target: router) { (data, error) in
            var loginResult: StatisticModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    loginResult = Mapper<StatisticModel>().map(JSONObject: json)
                } catch { }
            }
            completion(loginResult, error)
        }
    }
}
