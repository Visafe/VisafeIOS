//
//  ProtectHomeHeaderView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

class ProtectHomeHeaderView: BaseView {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var subIconImage: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subContentLabel: UILabel!
    @IBOutlet weak var modelSwitch: UISwitch!
    
    var switchValueChange:((_ value: Bool) -> Void)?
    
    var type: ProtectHomeType = .device
    
    class func loadFromNib() -> ProtectHomeHeaderView? {
        return self.loadFromNib(withName: ProtectHomeHeaderView.className)
    }
    
    func bindingData(type: ProtectHomeType) {
        self.type = type
        subIconImage.image = type.getImage()
        subTitleLabel.text = type.getTitle()
        subContentLabel.text = type.getContent()
        
        logoImage.image = type.getTopImage()
        titleLabel.attributedText = type.getTopTitle()
        contentLabel.text = type.getTopContent()
    }
    
    func updateState(isOn: Bool) {
        modelSwitch.isOn = isOn
        logoImage.image = isOn ? type.getTopImage() : type.getTopImagePositive()
        titleLabel.attributedText = isOn ? type.getTopTitle() : type.getTopTitlePositive()
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        let isOn = sender.isOn
        switchValueChange?(isOn)
        updateState(isOn: isOn)
    }
}
