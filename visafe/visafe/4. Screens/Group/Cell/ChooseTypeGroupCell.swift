//
//  ChooseTypeGroupCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit

class ChooseTypeGroupCell: UICollectionViewCell {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binding(group: GroupModel, type: GroupTypeEnum) {
        if group.object_type.contains(where: { (t) -> Bool in
            if t == type { return true } else { return false }
        }) {
            checkButton.setImage(UIImage(named: "ic_check"), for: .normal)
        } else {
            checkButton.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
        groupNameLabel.text = type.getDescription()
    }
}
