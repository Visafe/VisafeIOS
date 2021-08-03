//
//  LogHeaderView.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/3/21.
//

import UIKit

class LogHeaderView: BaseView {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    

    class func loadFromNib() -> LogHeaderView? {
        return self.loadFromNib(withName: LogHeaderView.className)
    }
    
    func bindingData(statistic: StatisticModel, typeTime: ChooseTimeEnum, typeSetting: GroupSettingParentEnum) {
        timeTitleLabel.text = typeTime.getSubTitle()
        switch typeSetting {
        case .ads_blocked:
            totalLabel.text = "\(statistic.num_ads_blocked_all)"
            timeLabel.text = "\(statistic.num_ads_blocked)"
        case .native_tracking:
            totalLabel.text = "\(statistic.num_native_tracking)"
            timeLabel.text = "\(statistic.num_native_tracking_all)"
        case .access_blocked:
            totalLabel.text = "\(statistic.num_access_blocked_all)"
            timeLabel.text = "\(statistic.num_access_blocked)"
        case .content_blocked:
            totalLabel.text = "\(statistic.num_content_blocked_all)"
            timeLabel.text = "\(statistic.num_content_blocked)"
        default:
            break
        }
    }

}
