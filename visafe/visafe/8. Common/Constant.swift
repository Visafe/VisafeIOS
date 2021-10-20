//
//  Constant.swift
//  EConversation
//
//  Created by Cuong Nguyen on 9/21/19.
//  Copyright © 2019 EConversation. All rights reserved.
//

import Foundation
import UIKit

// Screen
let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height
let keyWindow = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first
let kNavigationHeight: CGFloat = (keyWindow?.safeAreaInsets.top ?? 0) + 44
let kTabbarHeight: CGFloat = (keyWindow?.safeAreaInsets.bottom ?? 0) + 50

// TableName
let kDatabaseName = "ecdata"
let kLessonTitles = "lesson_titles"
let kLesson = "lessons"
let kLessonId = "lesson_ids"

let kNotificationUpdateWorkspace = "kNotificationUpdateWorkspace"
let updateDnsStatus = "updateDnsStatus"
let kPaymentSuccess = "kPaymentSuccess"

let dnsServer = "https://dns.visafe.vn/dns-query/%@"
//let dnsServer = "https://dns-staging.visafe.vn/dns-query/%@"
