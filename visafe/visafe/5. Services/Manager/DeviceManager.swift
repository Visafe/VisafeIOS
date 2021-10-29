//
//  DeviceManager.swift
//  TripTracker
//
//  Created by robert pham on 10/10/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let pushToken = DefaultsKey<String?>("pushToken")
}

class DeviceManager {
    
    static let shared = DeviceManager()
    
    let deviceType = 2 //iOS
    
    var pushToken: String? {
        set {
            Defaults[.pushToken] = newValue
        }
        get {
            return Defaults[.pushToken]
        }
    }
}
