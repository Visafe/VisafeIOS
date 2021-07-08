//
//  MoreLinkSettingView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

class MoreLinkSettingView: MessageView {

    @IBOutlet weak var nameLabel: UILabel!
    var editAction:(() -> Void)?
    var deleteAction:(() -> Void)?
    
    class func loadFromNib() -> MoreLinkSettingView? {
        return self.loadFromNib(withName: MoreLinkSettingView.className)
    }
    
    func binding(name: String?) {
        nameLabel.text = name
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        editAction?()
        SwiftMessages.hide()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        deleteAction?()
        SwiftMessages.hide()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        SwiftMessages.hide()
    }
}
