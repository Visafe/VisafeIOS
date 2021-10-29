//
//  GroupHeaderView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/10/21.
//

import UIKit

class GroupHeaderView: BaseView {
    
    var addGroupAction:(() -> Void)?
    var inviteGroupAction:(() -> Void)?
    
    class func loadFromNib() -> GroupHeaderView? {
        return self.loadFromNib(withName: GroupHeaderView.className)
    }
    
    @IBAction func addGroup(_ sender: Any) {
        addGroupAction?()
    }
    
    @IBAction func inviteGroup(_ sender: Any) {
        inviteGroupAction?()
    }
}
