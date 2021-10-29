//
//  MoreActionWorkspaceView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

class MoreActionLinkView: MessageViewBase {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var unBlockedAction:(() -> Void)?
    var deleteAction:(() -> Void)?
    
    class func loadFromNib() -> MoreActionLinkView? {
        return self.loadFromNib(withName: MoreActionLinkView.className)
    }
    
    func binding(groupName: String?, time: String?) {
        nameLabel.text = groupName
        timeLabel.text = time
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        unBlockedAction?()
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
