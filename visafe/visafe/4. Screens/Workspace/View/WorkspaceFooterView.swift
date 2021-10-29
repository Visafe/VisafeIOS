//
//  WorkspaceFooterView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class WorkspaceFooterView: BaseView {
    
    var actionAddWorkspace:(() -> Void)?
    
    class func loadFromNib() -> WorkspaceFooterView? {
        return self.loadFromNib(withName: WorkspaceFooterView.className)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func addWorkspaceAction(_ sender: Any) {
        actionAddWorkspace?()
    }
}
