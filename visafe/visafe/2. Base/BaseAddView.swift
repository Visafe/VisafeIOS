//
//  BaseAddView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/29/21.
//

import UIKit

public enum AddButtonEnum: Int {
    case member = 0
    case device = 1
}

class BaseAddView: UIView {
    
    @IBOutlet weak var addButton: UIButton!
    
    var addAction:(() -> Void)?
    
    class func loadFromNib() -> BaseAddView? {
        return self.loadFromNib(withName: BaseAddView.className)
    }
    
    func bindingInfo(type: AddButtonEnum) {
        switch type {
        case .member:
            addButton.setTitle("Thêm thành viên", for: .normal)
        case .device:
            addButton.setTitle("Thêm thiết bị", for: .normal)
        }
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addAction?()
    }
}
