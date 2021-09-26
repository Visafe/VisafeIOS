//
//  CheckDeviceView.swift
//  visafe
//
//  Created by Cuong Nguyen on 9/26/21.
//

import UIKit

class CheckDeviceView: BaseView {
    
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberMemberLabel: UILabel!
    var onCheckoutPress:(() -> Void)?
    
    class func loadFromNib() -> CheckDeviceView? {
        return self.loadFromNib(withName: CheckDeviceView.className)
    }
    
    func bindingData(group: DeviceCheckResult) {
        titleLabel.text = group.groupName
        letterLabel.text = group.groupName?.getLetterString()
        numberMemberLabel.text = "\(group.numberDevice ?? 0) thành viên"
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        onCheckoutPress?()
    }
    
}
