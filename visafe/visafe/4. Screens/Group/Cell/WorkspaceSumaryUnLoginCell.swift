//
//  WorkspaceSumaryUnLoginCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit

class WorkspaceSumaryUnLoginCell: BaseTableCell {
    var actionCreateGroup:(() -> Void)?
    var actionJoinGroup:(() -> Void)?
    
    @IBOutlet weak var workspaceNameLabel: UILabel!
    @IBOutlet weak var descriptionWorkspaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData() {
        let workspace = CacheManager.shared.getCurrentWorkspace()
        workspaceNameLabel.text = workspace?.name
        if workspace?.type == .enterprise {
            descriptionWorkspaceLabel.text = "Bảo vệ tổ chức của bạn trên môi trường mạng"
        } else {
            descriptionWorkspaceLabel.text = "Bảo vệ gia đình & người thân trên môi trường mạng"
        }
    }
    @IBAction func joinGroupAction(_ sender: Any) {
        actionJoinGroup?()
    }
    
    @IBAction func createGroupAction(_ sender: Any) {
        actionCreateGroup?()
    }
}
