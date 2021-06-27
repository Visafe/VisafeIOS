//
//  WorkspaceCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class WorkspaceCell: BaseTableCell {
    
    var moreAction:(() -> Void)?

    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binding(workspace: WorkspaceModel) {
        iconImageView.image = workspace.type?.getIcon()
        nameLabel.text = workspace.name
        descriptionLabel.text = "\(workspace.groupIds?.count ?? 0) nhóm"
        bindingRoleView(isOwner: workspace.isOwner)
    }
    
    func bindingRoleView(isOwner: Bool?) {
        if let owner = isOwner, owner {
            roleLabel.text = "Quản trị"
            roleLabel.textColor = UIColor.mainColorOrange()
            roleView.backgroundColor = UIColor(hexString: kColorMainOrange, transparency: 0.3)
            moreButton.isHidden = false
        } else {
            roleLabel.text = "Thành viên"
            roleLabel.textColor = UIColor.mainColorBlue()
            roleView.backgroundColor = UIColor(hexString: kColorMainBlue, transparency: 0.3)
            moreButton.isHidden = true
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        moreAction?()
    }
}
