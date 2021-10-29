//
//  Date+Ext.swift
//  TripTracker
//
//  Created by quangpc on 12/7/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    func timeAgo() -> String {
        let now = Date()
        let yearDif = (now - self).year ?? 0
        let monthDif = (now - self).month ?? 0
        let dayDif = (now - self).day ?? 0
        let weekDif = dayDif / 7
        let hourDif = (now - self).hour ?? 0
        let minDif = (now - self).minute ?? 0
        if yearDif > 0 {
            return yearDif > 1 ? "\(yearDif) years ago" : "\(yearDif) year ago"
        }
        if monthDif > 0 {
            return monthDif > 1 ? "\(monthDif) months ago" : "\(monthDif) month ago"
        }
        if weekDif > 0 {
            return weekDif > 1 ? "\(weekDif) weeks ago" : "\(weekDif) week ago"
        }
        if dayDif > 0 {
            return dayDif > 1 ? "\(dayDif) days ago" : "\(dayDif) day ago"
        }
        if hourDif > 0 {
            return hourDif > 1 ? "\(hourDif) hours ago" : "\(hourDif) hour ago"
        }
        if minDif > 0 {
            return minDif > 1 ? "\(minDif) mins ago" : "\(minDif) min ago"
        }
        return "Just now"
    }
    
}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
}
