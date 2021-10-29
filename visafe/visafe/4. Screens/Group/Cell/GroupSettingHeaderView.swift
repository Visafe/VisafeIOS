//
//  GroupSettingHeaderView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/1/21.
//

import UIKit

class GroupSettingHeaderView: BaseView {
    
    @IBOutlet weak var switchOn: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var switchChangeValue:(() -> Void)?
    var data: PostGroupModel?
    
    class func loadFromNib() -> GroupSettingHeaderView? {
        return self.loadFromNib(withName: GroupSettingHeaderView.className)
    }
    
    func binding(data: PostGroupModel) {
        self.data = data
        switchOn.isOn = data.isSelected ?? false
        titleLabel.text = data.type?.getTitle()
        contentLabel.text = data.type?.getDescription()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        data?.isSelected = sender.isOn
        switchChangeValue?()
    }
}
