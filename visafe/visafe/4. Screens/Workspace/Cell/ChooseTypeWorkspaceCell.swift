//
//  ChooseTypeWorkspaceCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit

class ChooseTypeWorkspaceCell: UICollectionViewCell {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var workspaceNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binding(workspace: WorkspaceModel, type: WorkspaceTypeEnum) {
        if workspace.type == type {
            checkButton.setImage(UIImage(named: "ic_check"), for: .normal)
        } else {
            checkButton.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
        workspaceNameLabel.text = type.getDescription()
    }
}
