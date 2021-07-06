//
//  BaseTextField.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/7/21.
//

import UIKit

public enum TextfiledStateEnum: Int {
    case normal = 1
    case active = 2
    case error = 3
}

class BaseTextField: UITextField {
    
    var type: TextfiledStateEnum = .normal
    
    func setState(type: TextfiledStateEnum) {
        switch type {
        case .normal:
            self.type = type
            borderColor = UIColor(hexString: "DDDDDD")
            borderWidth = 1
            cornerRadius = 8
        case .active:
            self.type = type
            borderColor = UIColor.mainColorOrange()
            borderWidth = 1
            cornerRadius = 8
        case .error:
            self.type = type
            borderColor = UIColor(hexString: "FF4451")
            borderWidth = 1
            cornerRadius = 8
        }
    }
}
