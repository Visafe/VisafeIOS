//
//  TabbarItemContentView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/18/21.
//

import UIKit
import ESTabBarController_swift

class TabbarItemContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        iconColor = UIColor.mainColorBlue()
        highlightIconColor = UIColor.mainColorOrange()
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 2, y: 2)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
