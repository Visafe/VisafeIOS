//
//  UIButtonExtension.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

extension UIButton {
    func centerButtonAndImageWithSpacing(spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
    }
}
