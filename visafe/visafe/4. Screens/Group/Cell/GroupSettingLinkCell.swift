//
//  GroupSettingLinkCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/3/21.
//

import UIKit

class GroupSettingLinkCell: BaseTableCell {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var moreAction:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binding(link: String) {
        linkLabel.text = link
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        moreAction?()
    }
}
