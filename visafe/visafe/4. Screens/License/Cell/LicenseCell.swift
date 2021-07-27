//
//  LicenseCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit

class LicenseCell: BaseTableCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(value: String) {
        titleLabel.text = value
    }
}
