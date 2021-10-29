//
//  UserManager.swift
//  TripTracker
//
//  Created by quangpc on 10/22/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let currentUser = DefaultsKey<User?>("currentUser")
    static let currentBusiness = DefaultsKey<Business?>("currentBusiness")
}

class UserManager {
    
    static let shared: UserManager = UserManager()
    
    var current: User?
    
    var currentBusiness: Business?
    
    init() {
        current = Defaults[.currentUser]
        currentBusiness = Defaults[.currentBusiness]
    }
    
    func isLoggedIn() -> Bool {
        
        return current != nil
    }
    
    func save(user: User) {
        Defaults[.currentUser] = user
        current = user
    }
    
    func save(business: Business) {
        Defaults[.currentBusiness] = business
        currentBusiness = business
    }
    
    func logout() {
        Defaults[.currentUser] = nil
        current = nil
        Defaults[.currentBusiness] = nil
        currentBusiness = nil
    }
    
    func updateLatestInfo(with user: User?) {
        guard let user = user, current != nil, user.id == current?.id else { return }
        current?.name = user.name
        current?.email = user.email
        current?.address = user.address
        current?.bio = user.bio
        current?.links = user.links
        current?.map_display_distance = user.map_display_distance
        current?.language = user.language
        current?.sex = user.sex
        current?.avatarURL = user.avatarURL
        current?.phone = user.phone
        current?.latitude = user.latitude
        current?.longitude = user.longitude
        if let authKey = user.auth_key, authKey.isEmpty == false {
            current?.auth_key = authKey
        }
        save(user: current!)
    }
}
