//
//  GroupDeviceCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

public enum DevcieTypeEnum: String {
    case desktop = "Desktop"
    case mobile = "Mobile"
    case tablet = "Tablet"
    case ioT = "IoT"
    
    func getIcon() -> UIImage? {
        switch self {
        case .desktop:
            return UIImage(named: "ic_device_destop")
        case .mobile:
            return UIImage(named: "ic_device_mobile")
        default:
            return UIImage(named: "ic_device_destop")
        }
    }
}

class GroupDeviceCell: BaseTableCell {

    var moreAction:(() -> Void)?

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binding(device: DeviceGroupModel) {
        nameLabel.text = device.deviceName
        descriptionLabel.text = device.deviceOwner ?? ""
        iconImageView.image = (device.deviceType?.getIcon() ?? UIImage(named: "ic_device_destop"))
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        moreAction?()
    }
}
