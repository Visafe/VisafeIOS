//
//  WorkspaceFooterView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class WorkspaceFooterView: BaseView {
    
    var actionAddWorkspace:(() -> Void)?
    var actionGuideBook:(() -> Void)?
    var actionSupport:(() -> Void)?
    
    class func loadFromNib() -> WorkspaceFooterView? {
        return self.loadFromNib(withName: WorkspaceFooterView.className)
    }
    
    @IBAction func addWorkspaceAction(_ sender: Any) {
        actionAddWorkspace?()
    }
    
    @IBAction func guideBookAction(_ sender: Any) {
        
    }
    
    @IBAction func supportAction(_ sender: Any) {
        
    }
}
