//
//  GroupDetailHeader.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/20/21.
//

import UIKit


class GroupDetailHeader: BaseView {

    @IBOutlet weak var contentWidth: NSLayoutConstraint!
    
    var addAction:(() -> Void)?
    var managerAction:(() -> Void)?
    
    class func loadFromNib() -> GroupDetailHeader? {
        return self.loadFromNib(withName: GroupDetailHeader.className)
    }
    
    func bindingData() {
        contentWidth.constant = kScreenWidth - 32
    }
    
    @IBAction func addMemberAction(_ sender: UIButton) {
        addAction?()
    }
    
    @IBAction func managerMemberAction(_ sender: UIButton) {
        managerAction?()
    }
}
