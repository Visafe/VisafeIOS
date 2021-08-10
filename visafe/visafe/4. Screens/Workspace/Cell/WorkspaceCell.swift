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
        nameLabel.text = workspace.name
        descriptionLabel.text = "\(workspace.groupIds?.count ?? 0) nhóm"
        bindingRoleView(isOwner: workspace.isOwner)
    }
    
    func bindingRoleView(isOwner: Bool?) {
        if let owner = isOwner, owner {
            roleLabel.text = "QUẢN TRỊ"
            roleLabel.textColor = UIColor.black
            roleView.backgroundColor = UIColor(hexString: "FFCE21")
            moreButton.isHidden = false
        } else {
            roleLabel.text = "THÀNH VIÊN"
            roleLabel.textColor = UIColor.white
            roleView.backgroundColor = UIColor.mainColorBlue()
            moreButton.isHidden = true
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        moreAction?()
    }
}
