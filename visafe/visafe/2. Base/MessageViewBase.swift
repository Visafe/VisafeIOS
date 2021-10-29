//
//  BaseMessageView.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/4/21.
//

import UIKit
import SwiftMessages

class MessageViewBase: MessageView {
    
    var bottomView: UIView = UIView()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        bottomView.frame = CGRect(x: 0, y: rect.height - 50, width: kScreenWidth, height: 50)
        bottomView.backgroundColor = .white
        bottomView.layer.zPosition = -1
        bottomView.isUserInteractionEnabled = false
        addSubview(bottomView)
    }
}
