//
//  GroupMemberCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

class GroupMemberCell: BaseTableCell {

    var moreAction:(() -> Void)?

    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binding(user: UserModel) {
        nameLabel.text = user.fullname
        descriptionLabel.text = user.email ?? user.phonenumber ?? "Chưa có email"
        bindingRoleView(isOwner: user.isOwner)
    }
    
    func bindingRoleView(isOwner: Bool?) {
        if let owner = isOwner, owner {
            roleLabel.text = "Chủ nhóm"
            roleLabel.textColor = UIColor.black
            roleView.backgroundColor = UIColor(hexString: "FFCE21")
            moreButton.isHidden = false
        } else {
            roleLabel.text = "Thành viên"
            roleLabel.textColor = UIColor.white
            roleView.backgroundColor = UIColor.mainColorBlue()
            moreButton.isHidden = true
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        moreAction?()
    }
}
