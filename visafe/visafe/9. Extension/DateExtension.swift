//
//  DateExtension.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/14/21.
//

import UIKit

extension Date {
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
    func getTimeOnFeed() -> String {
        if isInToday {
            let hour = Date().hour - self.hour
            if hour > 0 {
                return "\(hour) giờ trước"
            } else if hour == 0 {
                let minute = Date().minute - self.minute
                if minute > 0 {
                    return "\(minute) phút trước"
                } else if minute == 0 {
                    let second = Date().second - self.second
                    if second > 0 {
                        return "\(second) giây trước"
                    }
                }
            }
        } else if isInYesterday {
            return "Hôm qua"
        }
        return self.string(withFormat: "dd-MM-yyyy")
    }
}
