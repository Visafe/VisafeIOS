//
//  NotificationCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit

class NotificationCell: BaseTableCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(model: NotificationModel) {
        contentLabel.text = model.buildContent()
        timeLabel.text = model.buildTime()
    }
}
