//
//  StatisticCategoryCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/22/21.
//

import UIKit

class StatisticCategoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var contraintWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(category: StatisticCategory) {
        titleLabel.text = category.name?.getTitle()
        iconImageView.image = category.name?.getIcon()
        percentLabel.text = "\(category.percent)%"
    }
    
    func bindingData(app: StatisticCategoryApp) {
        titleLabel.text = app.name?.getTitle()
        iconImageView.image = app.name?.getIcon()
        percentLabel.text = "\(app.percent)%"
    }
}
