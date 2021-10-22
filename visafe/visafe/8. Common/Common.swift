//
//  Common.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/3/21.
//

import UIKit

class Common {
    
    class func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString.lowercased()
    }
    
    class func getDeviceInfo() -> AddDeviceToGroupParam {
        let param = AddDeviceToGroupParam()
        param.deviceName = UIDevice.current.name
        param.macAddress = UIDevice.current.identifierForVendor?.uuidString
        param.deviceId = CacheManager.shared.getDeviceId()
        param.ipAddress = "127.0.0.1"
        param.deviceType = UIDevice.current.model == "iPhone" ? "Mobile" : "Tablet"
        param.deviceOwner = UIDevice.current.name
        param.deviceDetail = "{\"iOSVersion\":\"30 (11)\",\"kernel\":\"4.14.190-20973144-abA715FXXU3BUB5\"}"
        return param
    }

    class func getDnsServer() -> String {
        if let _vip = CacheManager.shared.getVipDOH() {
            return _vip + CacheManager.shared.getDeviceId()
        }
        if let dns = CacheManager.shared.getDnsServer() {
            return String(format: dns, CacheManager.shared.getDeviceId())
        }
        return String(format: dnsServer, CacheManager.shared.getDeviceId())
    }
}
