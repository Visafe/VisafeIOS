//
//  GroupSettingCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/1/21.
//

import UIKit


//public class AppAdsModel: BaseGroupModel {
//    var type: GroupAppAdsEnum?
//}
//
//public class NativeTrackingModel: BaseGroupModel {
//    var type: NativeTrackingEnum?
//}
//
//public class BlockServiceModel: BaseGroupModel {
//    var type: NativeTrackingEnum?
//}
//
//public class SafeSearchModel: BaseGroupModel {
//    var type: SafesearchEnum?
//}


class GroupSettingCell: BaseTableCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var switchOn: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    var data: Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        if let d = data as? AppAdsModel {
            d.isSelected = sender.isOn
        } else if let d = data as? NativeTrackingModel {
            d.isSelected = sender.isOn
        } else if let d = data as? BlockServiceModel {
            d.isSelected = sender.isOn
        } else if let d = data as? SafeSearchModel {
            d.isSelected = sender.isOn
        }
    }
    
    func bindingData(ads: AppAdsModel?) {
        data = ads
        iconImageView.image = ads?.type?.getIcon()
        titleLabel.text = ads?.type?.getTitle()
        switchOn.isOn = ads?.isSelected ?? false
    }
    
    func bindingData(tracking: NativeTrackingModel?) {
        data = tracking
        iconImageView.image = tracking?.type?.getIcon()
        titleLabel.text = tracking?.type?.getTitle()
        switchOn.isOn = tracking?.isSelected ?? false
    }
    
    func bindingData(service: BlockServiceModel?) {
        data = service
        iconImageView.image = service?.type?.getIcon()
        titleLabel.text = service?.type?.getTitle()
        switchOn.isOn = service?.isSelected ?? false
    }
    
    func bindingData(safeSearch: SafeSearchModel?) {
        data = safeSearch
        iconImageView.image = safeSearch?.type?.getIcon()
        titleLabel.text = safeSearch?.type?.getTitle()
        switchOn.isOn = safeSearch?.isSelected ?? false
    }
}
