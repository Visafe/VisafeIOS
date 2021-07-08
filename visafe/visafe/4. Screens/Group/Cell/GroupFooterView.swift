//
//  GroupFooterView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class GroupFooterView: BaseView {

    @IBOutlet weak var addButton: UIButton!
    
    var onClickAddGroup:(() -> Void)?
    
    class func loadFromNib() -> GroupFooterView? {
        return self.loadFromNib(withName: GroupFooterView.className)
    }
    
    func configView() {
        addButton.centerButtonAndImageWithSpacing(spacing: 15)
    }
    
    @IBAction func action(_ sender: Any) {
        onClickAddGroup?()
    }
}
