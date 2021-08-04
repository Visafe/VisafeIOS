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
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropShadowEdge(color: UIColor = UIColor(red:0.32, green:0.32, blue:0.32, alpha:0.5),
                    opacity: Float = 0.8,
                    offset: CGSize = .init(width: 1.0, height: 1.0),
                    radius: CGFloat = 2.0,
                    shouldRasterize: Bool = false,
                    path: UIBezierPath? = nil,
                    rasterizationScale: CGFloat? = nil) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        if let path = path?.cgPath {
            self.layer.shadowPath = path
        }
        self.layer.shouldRasterize = shouldRasterize
        if let scale = rasterizationScale {
            self.layer.rasterizationScale = scale
        }
    }
}
