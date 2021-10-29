//
//  UIImageView+Extensions.swift
//  TripTracker
//
//  Created by quangpc on 11/23/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func app_setImage(urlString: String?, placeHolder: UIImage?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        sd_setImage(with: url, placeholderImage: placeHolder, options: [], completed: nil)
    }
    
    func configMarker(urlString: String) {
        layer.cornerRadius = 25
        contentMode = .scaleToFill
        clipsToBounds = true
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        app_setImage(urlString: urlString, placeHolder: nil)
    }
}
