//
//  GroupCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class GroupCell: BaseTableCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var onMoreAction:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(group: GroupModel) {
        titleLabel.text = group.name
    }
    
    @IBAction func onClickMoreButton(_ sender: Any) {
        onMoreAction?()
    }
}
