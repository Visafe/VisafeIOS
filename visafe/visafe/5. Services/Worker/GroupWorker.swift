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

//group
//case addGroup(param: GroupModel)
//case updateGroup(param: GroupModel)
//case renameGroup(param: RenameGroupParam)
//case deleteGroup(groupId: String)
//case addDeviceGroup(param: AddDeviceToGroupParam)
//case deleteDeviceGroup(param: DeleteDeviceToGroupParam)
//case createIdentifier(name: String, groupId: String)
//case updateIdentifier(name: String, groupId: String)
//case deleteIdentifier(id: String)
//case getIdentifier(id: String)
//case addDeviceToIden(param: AddDeviceToIdentifierParam)
//case deleteDeviceToIden(param: DeleteDeviceToIdentifierParam)
//case inviteToGroup(param: InviteToGroupParam)
//case deleteToGroup(param: DeleteToGroupParam)
//case changeManagerPermision(param: ChangeManagerPermisionParam)
//case changeViewerPermision(param: ChangeViewerPermisionParam)

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
        let router = APIRouter.renameGroup(param: param)
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
    
    static func delete(groupId: String, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.deleteGroup(groupId: groupId)
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
        let router = APIRouter.deleteToGroup(param: param)
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
}
