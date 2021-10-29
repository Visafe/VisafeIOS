//
//  MoreActionView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

public enum MoreActionEnum: Int {
    case group = 1
    case device = 2
    case workspace = 3
}

class MoreActionView: MessageViewBase {

    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleEditLabel: UILabel!
    @IBOutlet weak var titleDeleteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var editAction:(() -> Void)?
    var deleteAction:(() -> Void)?
    
    class func loadFromNib() -> MoreActionView? {
        return self.loadFromNib(withName: MoreActionView.className)
    }
    
    func binding(title: String, type: MoreActionEnum) {
        nameLabel.text = title
        switch type {
        case .group:
            titleEditLabel.text = "Chỉnh sửa thông tin nhóm"
            titleDeleteLabel.text = "Xóa nhóm"
            subTitleLabel.text = "Quản lý nhóm"
        case .device:
            titleEditLabel.text = "Chỉnh tên thiết bị"
            titleDeleteLabel.text = "Xóa thiết bị khỏi nhóm"
            subTitleLabel.text = "Thiết bị"
        case .workspace:
            titleEditLabel.text = "Chỉnh sửa workspace"
            titleDeleteLabel.text = "Xóa workspace"
            subTitleLabel.text = "Workspace"
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
