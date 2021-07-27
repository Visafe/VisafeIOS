//
//  LicensePackageCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/28/21.
//

import UIKit

class LicensePackageCell: BaseTableCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(type: LicenseTypeEnum, package: LicensePackageEnum) {
        if package == .month {
            priceLabel.text = type.getPriceMonth()
        } else {
            priceLabel.text = type.getPriceYear()
        }
        titleLabel.text = package.getTitle()
        contentLabel.text = package.getContent()
    }
}
