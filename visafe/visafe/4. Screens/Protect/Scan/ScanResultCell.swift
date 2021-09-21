//
//  LicenseCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit

class ScanResultCell: BaseTableCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindingData(value: String) {
        titleLabel.text = value
    }
}
