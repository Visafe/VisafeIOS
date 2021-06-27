//
//  ConfirmDeleteWorkspaceView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

class ConfirmDeleteWorkspaceView: MessageView {
    
    var acceptAction:(() -> Void)?
    var cancelAction:(() -> Void)?
    
    class func loadFromNib() -> ConfirmDeleteWorkspaceView? {
        return self.loadFromNib(withName: ConfirmDeleteWorkspaceView.className)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        acceptAction?()
        SwiftMessages.hide()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelAction?()
        SwiftMessages.hide()
    }
}
