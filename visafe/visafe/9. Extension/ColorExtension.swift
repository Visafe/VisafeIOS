//
//  ColorExtension.swift
//  EConversation
//
//  Created by Cuong Nguyen on 9/21/19.
//  Copyright © 2019 EConversation. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift

extension UIColor {
    
    class func mainColorOrange() -> UIColor {
        return UIColor.init(hexString: kColorMainOrange)!
    }
    
    class func mainColorBlue() -> UIColor {
        return UIColor.init(hexString: kColorMainBlue)!
    }
    
    class func mainColorGray() -> UIColor {
        return UIColor.init(hexString: "E6E6E6")!
    }
}
