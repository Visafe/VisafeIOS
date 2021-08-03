//
//  StatisticSumaryView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/23/21.
//

import UIKit

class StatisticSumaryView: BaseView {
    
    @IBOutlet weak var blockedLabel: UILabel!
    @IBOutlet weak var violationLabel: UILabel!
    @IBOutlet weak var dangerousLabel: UILabel!
    
    class func loadFromNib() -> StatisticSumaryView? {
        return self.loadFromNib(withName: StatisticSumaryView.className)
    }
    
    func bindingData(statit: StatisticModel) {
        blockedLabel.text = "\(statit.num_ads_blocked)"
        violationLabel.text = "\(statit.num_violation)"
        dangerousLabel.text = "\(statit.num_dangerous_domain)"
    }
}
