//
//  ProfileHeaderView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit

class ProfileHeaderView: BaseView {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var actionLogin:(() -> Void)?
    var actionProfile:(() -> Void)?
    
    class func loadFromNib() -> ProfileHeaderView? {
        return self.loadFromNib(withName: ProfileHeaderView.className)
    }
    
    func bindingData() {
        if let user = CacheManager.shared.getCurrentUser(), CacheManager.shared.getIsLogined() {
            avatarImageView.image = UIImage(named: "icon_login")
            titleLabel.text = user.fullname
            contentLabel.text = user.phonenumber ?? user.email
        } else {
            avatarImageView.image = UIImage(named: "icon_unlogin")
            titleLabel.text = "Đăng nhập"
            contentLabel.text = "Đăng nhập để bảo mật toàn diện"
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if CacheManager.shared.getIsLogined() {
            actionProfile?()
        } else {
            actionLogin?()
        }
    }
}
