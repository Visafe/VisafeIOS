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
        bindingIsRead(isRead: model.isRead ?? true)
    }
    
    func bindingIsRead(isRead: Bool) {
        if isRead {
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.white
            backgroundView = bgColorView
        } else {
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor(hexString: "FFB31F", transparency: 0.15)
            backgroundView = bgColorView
        }
    }
}
