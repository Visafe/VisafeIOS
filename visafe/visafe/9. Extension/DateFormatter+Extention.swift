//
//  DateFormatter+Extention.swift
//  VnAlert
//
//  Created by Đào Thanh Hải on 5/21/20.
//  Copyright © 2020 Đào Thanh Hải. All rights reserved.
//

import Foundation

extension DateFormatter {

    static func date(fromString str:String, format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: str)
    }
    
    static func string(fromDate date:Date, format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func timeAgoSinceDate(date: Date, currentDate: Date) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute,
                                                                              NSCalendar.Unit.hour,
                                                                              NSCalendar.Unit.day,
                                                                              NSCalendar.Unit.weekOfYear,
                                                                              NSCalendar.Unit.month,
                                                                              NSCalendar.Unit.year,
                                                                              NSCalendar.Unit.second],
                                                                             from: earliest, to: latest,
                                                                             options: NSCalendar.Options())
        if components.year ?? 0 >= 1 {
            return yearAgo(year: components.year)
        } else if components.month ?? 0 >= 1 {
            return monthAgo(month: components.month)
        } else if components.weekOfYear ?? 0 >= 1 {
            return weekAgo(weekOfYear: components.weekOfYear)
        } else if components.day ?? 0 >= 1 {
            return dayAgo(day: components.day)
        } else if components.hour ?? 0 >= 1 {
            return hourAgo(hour: components.hour)
        } else if components.minute ?? 0 >= 1 {
            return minuteAgo(minute: components.minute)
        } else {
            return secondAgo(second: components.second)
        }
    }

    static func yearAgo(year: Int?) -> String {
        guard let year = year else { return "" }
        return "\(year) năm trước"
    }

    static func monthAgo(month: Int?) -> String {
        guard let month = month else { return "" }
        return "\(month) tháng trước"
    }

    static func weekAgo(weekOfYear: Int?) -> String {
        guard let weekOfYear = weekOfYear else { return "" }
        return "\(weekOfYear) tuần trước"
    }

    static func dayAgo(day: Int?) -> String {
        guard let day = day else { return "" }
        return "\(day) ngày trước"
    }

    static func hourAgo(hour: Int?) -> String {
        guard let hour = hour else { return "" }
        return "\(hour) giờ trước"
    }

    static func minuteAgo(minute: Int?) -> String {
        guard let minute = minute else { return "" }
        return "\(minute) phút trước"
    }

    static func secondAgo(second: Int?) -> String {
        guard let second = second else { return "" }
        if second >= 3 {
            return "\(second) giây trước"
        } else {
            return "Vừa mới"
        }
    }

}
