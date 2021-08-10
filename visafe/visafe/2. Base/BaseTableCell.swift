//
//  BaseTableCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit

class BaseTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(hexString: "FFB31F", transparency: 0.25)
        selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
