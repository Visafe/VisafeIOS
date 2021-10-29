//
//  ProfileFooterView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit

class ProfileFooterView: BaseView {
    
    @IBOutlet weak var topRegisterContraint: NSLayoutConstraint!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var upgrade:(() -> Void)?
    var register:(() -> Void)?
    
    class func loadFromNib() -> ProfileFooterView? {
        return self.loadFromNib(withName: ProfileFooterView.className)
    }
    
    func bindingData() {
        let type = CacheManager.shared.getCurrentUser()?.accountType ?? .personal
        packageImage.image = type.getNextPackage().getLogo()
        descriptionLabel.text = type.getNextPackage().getDesciption()
        registerView.isHidden = CacheManager.shared.getIsLogined()
        
        topRegisterContraint.constant = CacheManager.shared.getIsLogined() ? -120 : -20
    }
    
    @IBAction func registerAction(_ sender: Any) {
        register?()
    }
    
    @IBAction func upgradeAction(_ sender: Any) {
        upgrade?()
    }
}
