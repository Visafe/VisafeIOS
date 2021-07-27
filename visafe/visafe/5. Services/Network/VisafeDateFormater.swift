//
//  VisafeDateFormater.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit
import ObjectMapper

open class ViSafeDateFormater: TransformType {
    
    public typealias Object = Date
    public typealias JSON = String
    //2021-07-27T08:29:44.52236616+07:00
    var dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSZZZ"
    var dateFormat2 = "yyyy-MM-dd'T'HH:mm:ss"
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let string = value as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.date(from:string) {
                return date
            } else {
                dateFormatter.dateFormat = dateFormat2
                return dateFormatter.date(from:string)
            }
        }
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = dateFormat
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    
    
}
