//
//  UIViewExtension.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

extension UIView {
   var safeAreaHeight: CGFloat {
       if #available(iOS 11, *) {
        return safeAreaLayoutGuide.layoutFrame.size.height
       }
       return bounds.height
  }
    var safeAreaTop: CGFloat {
         if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame.origin.y
         }
         return bounds.height
    }
}

extension UIView {
    class func loadFromNib<T>(withName nibName: String) -> T? {
        let nib  = UINib.init(nibName: nibName, bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        return nil
    }
}
