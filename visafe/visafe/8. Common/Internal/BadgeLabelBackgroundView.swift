//
//  BadgeLabelBackgroundView.swift
//  TripTracker
//
//  Created by quangpc on 10/8/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import UIKit

class BadgeLabelBackgroundView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.red
        layer.cornerRadius = bounds.size.width/2
    }

}
