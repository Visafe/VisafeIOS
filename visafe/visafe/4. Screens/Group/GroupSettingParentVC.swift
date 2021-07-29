//
//  GroupSettingParentVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

public enum GroupSettingParentEnum: Int {
    case blockAds = 0
    case blockFollow = 1
    case blockConnect = 2
    case blockContent = 3
    case blockVPN = 4
    
    func getImage() -> UIImage? {
        switch self {
        case .blockAds:
            return UIImage(named: "block_ads")
        case .blockFollow:
            return UIImage(named: "block_follow")
        case .blockConnect:
            return UIImage(named: "block_connect")
        case .blockContent:
            return UIImage(named: "block_content")
        case .blockVPN:
            return UIImage(named: "block_vpn")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .blockAds:
            return "Chặn quảng cáo"
        case .blockFollow:
            return "Chặn theo dõi"
        case .blockConnect:
            return "Chặn truy cập"
        case .blockContent:
            return "Chặn nội dung"
        case .blockVPN:
            return "Chặn VPN, Proxy"
        }
    }
    
    func getContent() -> String {
        switch self {
        case .blockAds:
            return "Đang chặn quảng cáo 1 số Website, Game & Ứng dụng"
        case .blockFollow:
            return "Đang chặn theo dõi từ Apple, Samsung & 3 nhà phát triển khác"
        case .blockConnect:
            return "Đang chặn truy cập vào 1 số Website, Game & Ứng dụng"
        case .blockContent:
            return "Đang chặn các nội dung người lớn, cờ bạc & tin giả"
        case .blockVPN:
            return "Đang chặn truy cập vào các VPN, Proxy"
        }
    }
    
    func getTitleNavi() -> String {
        switch self {
        case .blockAds:
            return "Thiết lập chặn quảng cáo"
        case .blockFollow:
            return "Thiết lập chặn theo dõi"
        case .blockConnect:
            return "Thiết lập chặn truy cập"
        case .blockContent:
            return "Thiết lập chặn nội dung"
        case .blockVPN:
            return ""
        }
    }
    
    static func getAll() -> [GroupSettingParentEnum] {
        return [.blockAds, .blockFollow, .blockConnect, .blockContent, .blockVPN]
    }
    
    func getTopImage() -> UIImage? {
        switch self {
        case .blockAds:
            return UIImage(named: "ic_detail_ads")
        case .blockFollow:
            return UIImage(named: "ic_detail_tracking")
        case .blockConnect:
            return UIImage(named: "ic_detail_connect")
        case .blockContent:
            return UIImage(named: "ic_detail_content")
        case .blockVPN:
            return UIImage(named: "")
        }
    }
    
    func getTopImagePositive() -> UIImage? {
        return UIImage(named: "ic_detail_unads")
    }
    
    func getTopTitle() -> String {
        switch self {
        case .blockAds:
            return "Đang bật chặn quảng cáo nhóm"
        case .blockFollow:
            return "Đang bật chặn theo dõi"
        case .blockConnect:
            return "Đang bật chặn truy cập"
        case .blockContent:
            return "Đang bật chặn nội dung"
        case .blockVPN:
            return ""
        }
    }
    
    func getTopTitlePositive() -> String {
        switch self {
        case .blockAds:
            return "Đang tắt chặn quảng cáo nhóm"
        case .blockFollow:
            return "Đang tắt chặn theo dõi"
        case .blockConnect:
            return "Đang tắt chặn truy cập"
        case .blockContent:
            return "Đang tắt chặn nội dung"
        case .blockVPN:
            return ""
        }
    }
    
    func getTopContent() -> String {
        switch self {
        case .blockAds:
            return "Website, Ứng dụng & Game"
        case .blockFollow:
            return "Apple, Samsung & 3 nhà phát triển khác"
        case .blockConnect:
            return "Website, Game & Ứng dụng"
        case .blockContent:
            return "Người lớn, cờ bạc & tin giả"
        case .blockVPN:
            return ""
        }
    }
    
    func getTypeQueryLog() -> QueryLogTypeEnum {
        switch self {
        case .blockAds:
            return .ads_blocked
        case .blockFollow:
            return .native_tracking
        case .blockConnect:
            return .access_blocked
        case .blockContent:
            return .content_blocked
        case .blockVPN:
            return .native_tracking
        }
    }
}

public class PostGroupParentModel: BaseGroupModel {
    var type: GroupSettingParentEnum?
    var children: [Any]?
}

class GroupSettingParentVC: BaseViewController {
    
    var group: GroupModel
    var editMode: EditModeEnum
    
    var onContinue:(() -> Void)?
    
    var sources: [PostGroupParentModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    init(group: GroupModel, editMode: EditModeEnum) {
        self.group = group
        self.editMode = editMode
        super.init(nibName: GroupSettingParentVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindingData()
    }
    
    func configView() {
        tableView.registerCells(cells: [GroupSettingParentCell.className])
    }
    
    func bindingData() {
        sources = group.getAllModel()
        tableView.reloadData()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        onContinue?()
    }
}

extension GroupSettingParentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sources[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupSettingParentCell.className) as? GroupSettingParentCell else {
            return UITableViewCell()
        }
        cell.bindingData(group: model)
        cell.actionMore = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = GroupSettingVC(group: weakSelf.group, editMode: weakSelf.editMode, parentType: model.type!)
            weakSelf.navigationController?.pushViewController(vc)
        }
        cell.switchAction = { [weak self] isOn in
            guard let weakSelf = self else { return }
            if isOn {
                weakSelf.group.setDefault(type: model.type!)
            } else {
                weakSelf.group.disable(type: model.type!)
            }
        }
        return cell
    }
}
