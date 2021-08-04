//
//  MoreActionMemberView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

class MoreActionMemberView: MessageViewBase {

    @IBOutlet weak var titleEditLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var editAction:(() -> Void)?
    var deleteAction:(() -> Void)?
    
    class func loadFromNib() -> MoreActionMemberView? {
        return self.loadFromNib(withName: MoreActionMemberView.className)
    }
    
    func binding(user: UserModel) {
        nameLabel.text = user.fullname
        switch user.role {
        case .admin:
            titleEditLabel.text = "Cấp quyền làm giám sát viên"
        default:
            titleEditLabel.text = "Cấp quyền làm quản trị viên"
        }
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
