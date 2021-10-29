//
//  PostGroupAboutCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class PostGroupAboutCell: BaseTableCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(type: PostGroupIntroEnum) {
        titleLabel.text = type.getTitle()
    }
}
