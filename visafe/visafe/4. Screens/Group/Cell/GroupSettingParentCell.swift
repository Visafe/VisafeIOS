//
//  GroupSettingParentCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class GroupSettingParentCell: BaseTableCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var allowrightImage: UIImageView!
    
    var actionMore:(() -> Void)?
    var group: PostGroupParentModel = PostGroupParentModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(group: PostGroupParentModel) {
        self.group = group
        iconImageView.image = group.type?.getImage()
        titleLabel.text = group.type?.getTitle()
        contentLabel.text = group.type?.getContent()
        if group.type == .blockVPN {
            settingButton.isHidden = true
            allowrightImage.isHidden = true
        } else {
            settingButton.isHidden = false
            allowrightImage.isHidden = false
        }
    }
    
    @IBAction func settingMoreAction(_ sender: UIButton) {
        actionMore?()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        group.isSelected = !group.isSelected!
    }
}
