//
//  GroupBlockCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit
import Kingfisher

class GroupLogCell: BaseTableCell {

    @IBOutlet weak var iconImageView: UIImageView!
    var moreAction:(() -> Void)?
    
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
        timeLabel.text = model.time?.getTimeOnFeed()
    }

    func bindingData(model: BotNetDetailModel) {
        domainLabel.text = model.getDomain()
        if let mw_type = model.mw_type, let url = URL(string: "https://www.google.com/s2/favicons?sz=96&domain_url=\(mw_type)") {
            iconImageView.kf.setImage(with: url)
        }
        timeLabel.text = model.lastseen?.getTimeOnFeed()
    }
    
    @IBAction func moreActionButton(_ sender: Any) {
        moreAction?()
    }
}
