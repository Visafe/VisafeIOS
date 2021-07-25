//
//  GroupBlockCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit
import Kingfisher

class GroupBlockCell: BaseTableCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(model: QueryLogModel) {
        domainLabel.text = model.question?.host
        if let urlString = model.question?.host, let url = URL(string: "https://www.google.com/s2/favicons?sz=96&domain_url=\(urlString)") {
            iconImageView.kf.setImage(with: url)
        }
    }
}
