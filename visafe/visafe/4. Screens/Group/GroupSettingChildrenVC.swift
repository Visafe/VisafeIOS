//
//  GroupSettingChildrenVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/9/21.
//

import UIKit

class GroupSettingChildrenVC: BaseViewController {
    
    var parentType: GroupSettingParentEnum

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(parentType: GroupSettingParentEnum) {
        self.parentType = parentType
        super.init(nibName: GroupSettingChildrenVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
