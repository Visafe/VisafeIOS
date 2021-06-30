//
//  CacheManager.swift
//  EConversation
//
//  Created by Cuong Nguyen on 9/25/19.
//  Copyright © 2019 EConversation. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

let kIsLogin = "kIsLogin"
let kLoginResult = "kLoginResult"
let kListWorkspace = "kListWorkspace"
let kCurrentWorkspace = "kCurrentWorkspace"
let kCurrentUser = "kCurrentUser"

class CacheManager {
    
    static let shared = CacheManager()
    
    let userDefault = UserDefaults()
    
    func getIsLogined() -> Bool {
        let value = userDefault.bool(forKey: kIsLogin)
        return value
    }
    
    func setIsLogined(value: Bool) {
        userDefault.set(value, forKey: kIsLogin)
        userDefault.synchronize()
    }
    
    func getLoginResult() -> LoginResult? {
        if let value = userDefault.string(forKey: kLoginResult) {
            return Mapper<LoginResult>().map(JSONString: value)
        }
        return nil
    }
    
    func setLoginResult(value: LoginResult?) {
        userDefault.set(value?.toJSONString(), forKey: kLoginResult)
        userDefault.synchronize()
    }
    
    func getWorkspacesResult() -> [WorkspaceModel]? {
        if let value = userDefault.string(forKey: kListWorkspace) {
            return Mapper<WorkspaceModel>().mapArray(JSONString: value)
        }
        return nil
    }
    
    func setWorkspacesResult(value: [WorkspaceModel]?) {
        userDefault.set(value?.toJSONString(), forKey: kListWorkspace)
        userDefault.synchronize()
    }
    
    func getCurrentWorkspace() -> WorkspaceModel? {
        if let value = userDefault.string(forKey: kCurrentWorkspace) {
            return Mapper<WorkspaceModel>().map(JSONString: value)
        }
        return nil
    }
    
    func setCurrentWorkspace(value: WorkspaceModel?) {
        userDefault.set(value?.toJSONString(), forKey: kCurrentWorkspace)
        userDefault.synchronize()
    }
    
    func getCurrentUser() -> UserModel? {
        if let value = userDefault.string(forKey: kCurrentUser) {
            return Mapper<UserModel>().map(JSONString: value)
        }
        return nil
    }
    
    func setCurrentUser(value: UserModel?) {
        userDefault.set(value?.toJSONString(), forKey: kCurrentUser)
        userDefault.synchronize()
    }
}
