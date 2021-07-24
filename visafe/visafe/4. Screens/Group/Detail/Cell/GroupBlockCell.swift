//
//  GroupBlockCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit

class GroupBlockCell: UITableViewCell {

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
        
    }
}
