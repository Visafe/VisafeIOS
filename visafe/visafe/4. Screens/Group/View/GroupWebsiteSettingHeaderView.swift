//
//  GroupWebsiteSettingHeaderView.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/1/21.
//

import UIKit

public enum GroupWebsiteSettingHeaderEnum: Int {
    case block = 1
    case white = 2
}

class GroupWebsiteSettingHeaderView: BaseView {
    
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var blockSelectedView: UIView!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var whiteSelectedView: UIView!
    
    var onChangeTab:((_ tab: GroupWebsiteSettingHeaderEnum) -> Void)?
    var data: PostGroupModel?
    
    class func loadFromNib() -> GroupWebsiteSettingHeaderView? {
        return self.loadFromNib(withName: GroupWebsiteSettingHeaderView.className)
    }
    
    func binding(type: GroupWebsiteSettingHeaderEnum) {
        if type == .white {
            whiteButton.setTitleColor(UIColor.mainColorOrange(), for: .normal)
            whiteSelectedView.isHidden = false
            blockSelectedView.isHidden = true
            blockButton.setTitleColor(.lightGray, for: .normal)
        } else {
            blockButton.setTitleColor(UIColor.mainColorOrange(), for: .normal)
            blockSelectedView.isHidden = false
            whiteSelectedView.isHidden = true
            whiteButton.setTitleColor(.lightGray, for: .normal)
        }
        onChangeTab?(type)
    }
    
    @IBAction func blockWebsiteAction(_ sender: Any) {
        binding(type: .block)
    }
    
    @IBAction func whiteWebsiteAction(_ sender: Any) {
        binding(type: .white)
    }
}
