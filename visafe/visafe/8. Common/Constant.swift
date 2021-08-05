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


// ListColorRandon
let hexRandomColor: [String] = ["54C0EB", "C18EFC", "63C663", "F89B4B", "F5766B", "3FBE8D", "FF7E8C", "F89B4B", "45C66C"]

// Color
let kColorMainOrange = "FFB31F"
let kColorMainBlue = "33B6FF"

// TableName
let kDatabaseName = "ecdata"
let kLessonTitles = "lesson_titles"
let kLesson = "lessons"
let kLessonId = "lesson_ids"

let kNotificationUpdateWorkspace = "kNotificationUpdateWorkspace"
let updateDnsStatus = "updateDnsStatus"

let dnsServer = "https://dns-staging.visafe.vn/dns-query/%@"
