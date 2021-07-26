//
//  MoreActionWorkspaceView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

class MoreActionLinkView: MessageView {

    @IBOutlet weak var nameLabel: UILabel!
    var unBlockedAction:(() -> Void)?
    var deleteAction:(() -> Void)?
    
    class func loadFromNib() -> MoreActionLinkView? {
        return self.loadFromNib(withName: MoreActionLinkView.className)
    }
    
    func binding(workspaceName: String?) {
        nameLabel.text = workspaceName
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
