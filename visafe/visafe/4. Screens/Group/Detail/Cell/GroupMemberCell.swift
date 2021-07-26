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
        bindingRoleView(role: user.role)
    }
    
    func bindingRoleView(role: GroupMemberRoleEnum) {
        roleLabel.text = role.getTitle()
        if role == .admin || role == .owner {
            roleLabel.textColor = UIColor.mainColorOrange()
            roleView.backgroundColor = UIColor(hexString: "FFF9ED")
            if role == .owner {
                moreButton.isHidden = true
            } else {
                moreButton.isHidden = false
            }
        } else {
            roleLabel.textColor = UIColor.mainColorBlue()
            roleView.backgroundColor = UIColor(hexString: "ECF7FF")
            moreButton.isHidden = false
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        moreAction?()
    }
}
