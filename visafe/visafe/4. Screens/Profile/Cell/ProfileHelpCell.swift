//
//  ProfileHelpCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit

class ProfileHelpCell: UITableViewCell {

    @IBOutlet weak var contentButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(type: ProfileHelpNowEnum) {
        iconImageView.image = type.getIcon()
        titleLabel.text = type.getTitle()
        contentButton.setTitle(type.getContent(), for: .normal)
    }
}
