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
    
    static func getAllModel() -> [PostGroupParentModel] {
        var sources: [PostGroupParentModel] = []
        let enums: [GroupSettingParentEnum] = [.blockAds, .blockFollow, .blockConnect, .blockContent, .blockVPN]
        for item in enums {
            let model = PostGroupParentModel()
            model.type = item
            model.isSelected = true
            sources.append(model)
        }
        return sources
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
    
    var sources: [PostGroupParentModel] = GroupSettingParentEnum.getAllModel()
    
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
        tableView.reloadData()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if editMode == .add {
            showLoading()
            GroupWorker.add(group: group) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(group: result, error: error)
            }
        } else {
            let param = RenameGroupParam()
            param.group_id = group.groupid
            param.group_name = group.name
            showLoading()
            GroupWorker.rename(param: param) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                GroupWorker.update(group: weakSelf.group) { [weak self] (result, error) in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading()
                    weakSelf.handleResponseUpdate(group: result, error: error)
                }
            }
        }
    }
    
    func handleResponse(group: GroupModel?, error: Error?) {
        if group != nil {
            showMemssage(title: "Tạo nhóm thành công", content: "Nhóm của bạn đã được áp dụng các thiết lập mà bạn khởi tạo.") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.parent?.dismiss(animated: true, completion: nil)
            }
        } else {
            showError(title: "Tạo nhóm không thành công", content: "Có lỗi xảy ra. Vui lòng thử lại")
        }
    }
    
    func handleResponseUpdate(group: GroupModel?, error: Error?) {
        if error == nil {
            showMemssage(title: "Sửa nhóm thành công", content: "Nhóm của bạn đã được áp dụng các thiết lập mà bạn cập nhật.") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.parent?.dismiss(animated: true, completion: nil)
            }
        } else {
            showError(title: "Sửa nhóm không thành công", content: "Có lỗi xảy ra. Vui lòng thử lại")
        }
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
        return cell
    }
}
