//
//  StatisticSumaryCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/23/21.
//

import UIKit

class StatisticSumaryCell: UITableViewCell {

    @IBOutlet weak var blockedLabel: UILabel!
    @IBOutlet weak var violationLabel: UILabel!
    @IBOutlet weak var dangerousLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(statit: StatisticModel) {
        blockedLabel.text = "\(statit.num_ads_blocked)"
        violationLabel.text = "\(statit.num_violation)"
        dangerousLabel.text = "\(statit.num_dangerous_domain)"
    }
}
