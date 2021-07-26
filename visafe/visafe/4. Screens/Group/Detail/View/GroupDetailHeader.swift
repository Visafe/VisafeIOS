//
//  GroupDetailHeader.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/20/21.
//

import UIKit


class GroupDetailHeader: BaseView {

    @IBOutlet weak var numDeviceLabel: UILabel!
    @IBOutlet weak var numMemberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortTitleLabel: UILabel!
    @IBOutlet weak var contentWidth: NSLayoutConstraint!
    
    var addAction:(() -> Void)?
    var managerAction:(() -> Void)?
    var viewMemberAction:(() -> Void)?
    var viewDeviceAction:(() -> Void)?
    
    class func loadFromNib() -> GroupDetailHeader? {
        return self.loadFromNib(withName: GroupDetailHeader.className)
    }
    
    func bindingData(group: GroupModel) {
        titleLabel.text = group.name
        sortTitleLabel.text = group.name?.getLetterString()
        contentWidth.constant = kScreenWidth - 32
        numMemberLabel.text = "\(group.usersGroupInfo.count) thành viên"
        numDeviceLabel.text = "\(group.devicesGroupInfo.count) thiết bị"
    }
    
    @IBAction func addMemberAction(_ sender: UIButton) {
        addAction?()
    }
    
    @IBAction func managerMemberAction(_ sender: UIButton) {
        managerAction?()
    }
    @IBAction func actionViewMember(_ sender: Any) {
        viewMemberAction?()
    }
    
    @IBAction func actionViewDevice(_ sender: Any) {
        viewDeviceAction?()
    }
}
