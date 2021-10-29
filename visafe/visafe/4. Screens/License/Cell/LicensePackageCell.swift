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
    
    func bindingData(price: PackagePriceModel) {
        if price.isBusiness {
            priceLabel.text = "Liên hệ"
            titleLabel.text = "Gói 12 tháng"
            contentLabel.text = "+90 NGÀY DÙNG THỬ"
        } else {
            priceLabel.text = "\(price.price)₫ / Tháng"
            titleLabel.text = "Gói \(price.duration) tháng"
            contentLabel.text = "+ \(price.day_trail) NGÀY DÙNG THỬ"
        }
    }
}
