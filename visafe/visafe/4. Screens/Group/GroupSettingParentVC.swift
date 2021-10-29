//
//  GroupSettingParentVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

public enum GroupSettingParentEnum: Int {
    case ads_blocked = 0
    case native_tracking = 1
    case access_blocked = 2
    case content_blocked = 3
    case blockVPN = 4
    
    func getImage() -> UIImage? {
        switch self {
        case .ads_blocked:
            return UIImage(named: "block_ads")
        case .native_tracking:
            return UIImage(named: "block_follow")
        case .access_blocked:
            return UIImage(named: "block_connect")
        case .content_blocked:
            return UIImage(named: "block_content")
        case .blockVPN:
            return UIImage(named: "block_vpn")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .ads_blocked:
            return "Chặn quảng cáo"
        case .native_tracking:
            return "Chặn theo dõi"
        case .access_blocked:
            return "Chặn truy cập"
        case .content_blocked:
            return "Chặn nội dung"
        case .blockVPN:
            return "Chặn VPN, Proxy"
        }
    }
    
    func getContent() -> String {
        switch self {
        case .ads_blocked:
            return "Đang chặn quảng cáo 1 số Website, Game & Ứng dụng"
        case .native_tracking:
            return "Đang chặn theo dõi từ Apple, Samsung & 3 nhà phát triển khác"
        case .access_blocked:
            return "Đang chặn truy cập vào 1 số Website, Game & Ứng dụng"
        case .content_blocked:
            return "Đang chặn các nội dung người lớn, cờ bạc & tin giả"
        case .blockVPN:
            return "Đang chặn truy cập vào các VPN, Proxy"
        }
    }
    
    func getTitleNavi() -> String {
        switch self {
        case .ads_blocked:
            return "Thiết lập chặn quảng cáo"
        case .native_tracking:
            return "Thiết lập chặn theo dõi"
        case .access_blocked:
            return "Thiết lập chặn truy cập"
        case .content_blocked:
            return "Thiết lập chặn nội dung"
        case .blockVPN:
            return ""
        }
    }
    
    static func getAll() -> [GroupSettingParentEnum] {
        return [.ads_blocked, .native_tracking, .access_blocked, .content_blocked, .blockVPN]
    }
    
    func getTopImage() -> UIImage? {
        switch self {
        case .ads_blocked:
            return UIImage(named: "ic_detail_ads")
        case .native_tracking:
            return UIImage(named: "ic_detail_tracking")
        case .access_blocked:
            return UIImage(named: "ic_detail_connect")
        case .content_blocked:
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
        case .ads_blocked:
            return "Đang bật chặn quảng cáo nhóm"
        case .native_tracking:
            return "Đang bật chặn theo dõi"
        case .access_blocked:
            return "Đang bật chặn truy cập"
        case .content_blocked:
            return "Đang bật chặn nội dung"
        case .blockVPN:
            return ""
        }
    }
    
    func getTopTitlePositive() -> String {
        switch self {
        case .ads_blocked:
            return "Đang tắt chặn quảng cáo nhóm"
        case .native_tracking:
            return "Đang tắt chặn theo dõi"
        case .access_blocked:
            return "Đang tắt chặn truy cập"
        case .content_blocked:
            return "Đang tắt chặn nội dung"
        case .blockVPN:
            return ""
        }
    }
    
    func getTopContent() -> String {
        switch self {
        case .ads_blocked:
            return "Website, Ứng dụng & Game"
        case .native_tracking:
            return "Apple, Samsung & 3 nhà phát triển khác"
        case .access_blocked:
            return "Website, Game & Ứng dụng"
        case .content_blocked:
            return "Người lớn, cờ bạc & tin giả"
        case .blockVPN:
            return ""
        }
    }
    
    func getTypeQueryLog() -> QueryLogTypeEnum {
        switch self {
        case .ads_blocked:
            return .ads_blocked
        case .native_tracking:
            return .native_tracking
        case .access_blocked:
            return .access_blocked
        case .content_blocked:
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
