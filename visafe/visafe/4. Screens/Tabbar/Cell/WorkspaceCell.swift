//
//  WorkspaceCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class WorkspaceCell: BaseTableCell {

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
    }
}
