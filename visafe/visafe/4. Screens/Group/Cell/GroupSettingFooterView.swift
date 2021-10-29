//
//  GroupSettingFooterView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class GroupSettingFooterView: BaseView {

    @IBOutlet weak var addButton: UIButton!
    
    var onClickAddLink:(() -> Void)?
    
    class func loadFromNib() -> GroupSettingFooterView? {
        return self.loadFromNib(withName: GroupSettingFooterView.className)
    }
    
    func configView() {
        addButton.centerButtonAndImageWithSpacing(spacing: 15)
    }
    
    @IBAction func action(_ sender: Any) {
        onClickAddLink?()
    }
}
