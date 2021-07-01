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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(ads: AppAdsModel?) {
        iconImageView.image = ads?.type?.getIcon()
        titleLabel.text = ads?.type?.getTitle()
        switchOn.isOn = ads?.isSelected ?? false
    }
    
    func bindingData(tracking: NativeTrackingModel?) {
        iconImageView.image = tracking?.type?.getIcon()
        titleLabel.text = tracking?.type?.getTitle()
        switchOn.isOn = tracking?.isSelected ?? false
    }
    
    func bindingData(service: BlockServiceModel?) {
        iconImageView.image = service?.type?.getIcon()
        titleLabel.text = service?.type?.getTitle()
        switchOn.isOn = service?.isSelected ?? false
    }
    
    func bindingData(safeSearch: SafeSearchModel?) {
        iconImageView.image = safeSearch?.type?.getIcon()
        titleLabel.text = safeSearch?.type?.getTitle()
        switchOn.isOn = safeSearch?.isSelected ?? false
    }
}
