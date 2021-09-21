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
let kShowOnboarding = "kShowOnboarding"
let kPin = "kPin"
let kDeviceId = "kDeviceId"
let kProtectWifi = "kProtectWifi"
let kLoginSuccess = "kLoginSuccess"
let kLastScan = "kLastScan"
let kPassword = "kPassword"
let kNotification = "kNotification"

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
    
    func removeCurrentUser() {
        userDefault.removeObject(forKey: kCurrentUser)
        userDefault.synchronize()
    }
    
    func getIsShowOnboarding() -> Bool {
        let value = userDefault.bool(forKey: kShowOnboarding)
        return value
    }
    
    func setIsShowOnboarding(value: Bool) {
        userDefault.set(value, forKey: kShowOnboarding)
        userDefault.synchronize()
    }
    
    func getPin() -> String? {
        let value = userDefault.string(forKey: kPin)
        return value
    }
    
    func setPin(value: String?) {
        userDefault.set(value, forKey: kPin)
        userDefault.synchronize()
    }
    
    func getDeviceId() -> String {
        if let value = userDefault.string(forKey: kDeviceId) {
            return value
        } else {
            let deviceId = Common.randomString(length: 12)
            setDeviceId(value: deviceId)
            return deviceId
        }
    }
    
    func setDeviceId(value: String) {
        userDefault.set(value, forKey: kDeviceId)
        userDefault.synchronize()
    }

    func isDeviceIdExist() -> Bool {
        return userDefault.string(forKey: kDeviceId) != nil 
    }

    func getProtectWifiStatus() -> Bool {
        let value = userDefault.bool(forKey: kProtectWifi)
        return value
    }

    func setProtectWifiStatus(value: Bool) {
        userDefault.set(value, forKey: kProtectWifi)
        userDefault.synchronize()
    }

    func setLastScan() {
        userDefault.set(Date(), forKey: kLastScan)
        userDefault.synchronize()
    }

    func getLastScan() -> Date? {
        return userDefault.date(forKey: kLastScan)
    }
    
    func getPassword() -> String? {
        let value = userDefault.string(forKey: kPassword)
        return value
    }
    
    func setPassword(value: String) {
        userDefault.set(value, forKey: kPassword)
        userDefault.synchronize()
    }
    
    func upNotificationCount() -> Int {
        var count = userDefault.integer(forKey: kNotification)
        count += 1
        userDefault.setValue(count, forKey: kNotification)
        userDefault.synchronize()
        return count
    }
    
    func resetNotificationCount() {
        userDefault.setValue(0, forKey: kNotification)
        userDefault.synchronize()
    }
}
