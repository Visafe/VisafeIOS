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
    func hex()->String {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)
        let alphaInt = Int(alpha * 255)

        let redHex = String(format: "%02x", redInt)
        let greenHex = String(format: "%02x", greenInt)
        let blueHex = String(format: "%02x", blueInt)
        let alphaHex = String(format: "%02x", alphaInt)

        return "#\(redHex)\(greenHex)\(blueHex)\(alphaHex)"
    }
    
    class func mainColorOrange() -> UIColor {
        return UIColor.init(hexString: kColorMainOrange)!
    }
    
    class func mainColorBlue() -> UIColor {
        return UIColor.init(hexString: kColorMainBlue)!
    }
    
    class func mainColorGray() -> UIColor {
        return UIColor.init(hexString: "E6E6E6")!
    }

    static let color_0F1733 = UIColor(hexString: "0F1733")!
    static let color_102366 = UIColor(hexString: "102366")!
    static let color_030E37 = UIColor(hexString: "030E37")!
    static let color_2C3163 = UIColor(hexString: "2C3163")!
}
