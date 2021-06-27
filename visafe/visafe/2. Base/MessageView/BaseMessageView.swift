//
//  BaseMessageView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/26/21.
//

import UIKit
import SwiftMessages

class BaseMessageView: MessageView {
    
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleNotiLabel: UILabel!
    @IBOutlet weak var contentNotiLabel: UILabel!
    class func loadFromNib() -> BaseMessageView? {
        return self.loadFromNib(withName: BaseMessageView.className)
    }
    
    func binding(title: String, content: String?) {
        titleNotiLabel.text = title
        contentNotiLabel.text = content
    }
    @IBAction func action(_ sender: UIButton) {
        buttonTapHandler?(sender)
    }
}
