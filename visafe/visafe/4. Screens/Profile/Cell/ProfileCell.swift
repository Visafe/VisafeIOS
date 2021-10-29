//
//  ProfileCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit

class ProfileCell: BaseTableCell {
    
    @IBOutlet weak var heightFooterLineContraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(type: ProfileEnum) {
        titleLabel.text = type.getTitle()
        iconImageView.image = type.getIcon()
        heightFooterLineContraint.constant = type.getFoooterLineHeight()
        if type == .upgradeAccount {
            contentImage.isHidden = false
            contentLabel.isHidden = true
            let type = CacheManager.shared.getCurrentUser()?.accountType ?? .personal
            contentImage.image = type.getLogo()
        } else {
            contentImage.isHidden = true
            contentLabel.isHidden = false
            contentLabel.text = type.getContent()
        }
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
