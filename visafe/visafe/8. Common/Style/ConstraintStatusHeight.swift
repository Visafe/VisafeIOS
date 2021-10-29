//
//  ConstraintStatusHeight.swift
//  TripTracker
//
//  Created by Hung NV on 5/24/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import UIKit

class ConstraintStatusHeight: NSLayoutConstraint {
    override func awakeFromNib() {
        super.awakeFromNib()
        constant = UIApplication.shared.statusBarFrame.size.height
    }
}
