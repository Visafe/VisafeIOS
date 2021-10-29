//
//  BlueButton.swift
//  TripTracker
//
//  Created by Hung NV on 5/24/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonBorder: UIButton {
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var borderWith:CGFloat = 0
    @IBInspectable var borderColor:UIColor = UIColor.clear
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBorder(borderColor, cornerRadius: cornerRadius, borderWith: borderWith)
    }
}

class BlueButton: ButtonBorder {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setTitleColor(UIColor.white, for: .normal)
        setBackgroundImage(AppColor.blue.toImage(), for: .normal)
        setBackgroundImage(AppColor.blue.withAlphaComponent(0.5).toImage(), for: .highlighted)
        self.backgroundColor = UIColor.clear
    }
    
}
class CircleImage: UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
    }
}
class LabelBlue: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = AppColor.blue
    }
}
class LabelGray: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = "9F9898".toColor()
    }
}


