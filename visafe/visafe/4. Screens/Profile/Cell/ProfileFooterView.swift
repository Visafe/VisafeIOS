//
//  ProfileFooterView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit

class ProfileFooterView: BaseView {
    
    var upgrade:(() -> Void)?
    
    class func loadFromNib() -> ProfileFooterView? {
        return self.loadFromNib(withName: ProfileFooterView.className)
    }

    @IBAction func upgradeAction(_ sender: Any) {
        upgrade?()
    }
}
