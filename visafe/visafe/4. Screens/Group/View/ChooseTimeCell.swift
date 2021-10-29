//
//  ChooseTimeCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit

class ChooseTimeCell: BaseTableCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(type: ChooseTimeEnum) {
        titleLabel.text = type.getTitle()
    }
}
