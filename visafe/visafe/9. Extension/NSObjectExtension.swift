//
//  NSObjectExtension.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
