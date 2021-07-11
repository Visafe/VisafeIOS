//
//  ProfileCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit

class ProfileCell: BaseTableCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(type: ProfileEnum) {
        titleLabel.text = type.getTitle()
        contentLabel.text = type.getContent()
        iconImageView.image = type.getIcon()
    }
    
    func bindingData(type: ProfileSettingEnum) {
        titleLabel.text = type.getTitle()
        contentLabel.text = type.getContent()
        iconImageView.image = type.getIcon()
    }
    
    func bindingData(type: ProfileHelpEnum) {
        titleLabel.text = type.getTitle()
        iconImageView.image = type.getIcon()
        contentLabel.text = nil
    }
}
