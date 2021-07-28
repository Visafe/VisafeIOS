//
//  UIImageViewExtension.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/28/21.
//

import UIKit

extension UIImageView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.5
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func endRotate() {
        self.layer.removeAllAnimations()
    }
}
