//
//  GroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SwiftMessages
import AVFoundation

class GroupVC: BaseViewController {
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var myGroups: [GroupModel] = []
    var inviteGroups: [GroupModel] = []
    var scrollDelegateFunc: ((UIScrollView)->Void)?
    var statisticModel: StatisticModel = StatisticModel()
    var selectedWorkspace:((_ workspace: WorkspaceModel?) -> Void)?
    var checkDevice: DeviceCheckResult?
    var timeType: ChooseTimeEnum = .day
    var onUpdateWorkspace:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshData()
        configView()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func configView() {
        // tableview
        tableView.registerCells(cells: [GroupCell.className, WorkspaceSumaryCell.className, WorkspaceSumaryUnLoginCell.className])
        tableView.backgroundColor = UIColor.clear
        
        guard let wsp = CacheManager.shared.getCurrentWorkspace() else { return }
        updateViewWithWsp(wsp: wsp)
    }
    
    func updateViewWithWsp(wsp: WorkspaceModel?) {
        if let workspace = CacheManager.shared.getCurrentWorkspace(), workspace.type == .enterprise {
            typeView.backgroundColor = UIColor(hexString: "FADFE1")
        } else {
            typeView.backgroundColor = UIColor(hexString: "FFD98F")
        }
    }
    
    func showFormAddGroup() {
        let vc = PostGroupAboutVC()
        vc.startAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.postGroup()
        }
        present(vc, animated: true, completion: nil)
    }
    
    func showFormAddWorkspace() {
        let vc = PostWorkspacesVC(workspace: WorkspaceModel(), editMode: .add)
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func postGroup() {
        let postVC = PostGroupVC()
        postVC.onDone = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
        let nav = BaseNavigationController(rootViewController: postVC)
        present(nav, animated: true, completion: nil)
    }
    
    func prepareData() {
        guard let wspId = CacheManager.shared.getCurrentWorkspace()?.id else { return }
        showLoading()
        WorkspaceWorker.getStatistic(wspId: wspId, limit: timeType.rawValue) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            if let model = result {
                weakSelf.statisticModel = model
            }
            GroupWorker.list(wsid: wspId) { [weak self] (result, error, responseCode) in
                guard let strongSelf = self else { return }
                strongSelf.hideLoading()
                strongSelf.myGroups = result?.clients?.filter({ (m) -> Bool in
                    return m.isOwner == true
                }) ?? []
                strongSelf.inviteGroups = result?.clients?.filter({ (m) -> Bool in
                    return m.isOwner == false
                }) ?? []
                strongSelf.tableView.reloadData()
                strongSelf.getCheckDevice()
            }
        }
    }
    
    func getCheckDevice() {
        GroupWorker.checkDevice { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.tableView.endRefreshing()
            weakSelf.checkDevice = result
            weakSelf.updateCheckDevice()
        }
    }
    
    func updateCheckDevice() {
        if let device = checkDevice, device.groupId != nil, let viewFooter = CheckDeviceView.loadFromNib() {
            viewFooter.bindingData(group: device)
            viewFooter.onCheckoutPress = {
                self.showConfirmDelete(title: "Bạn có chắc chắn muốn rời khỏi nhóm?") { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.actionRequestGroup(device: device)
                }
            }
            tableView.tableFooterView = viewFooter
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    func actionRequestGroup(device: DeviceCheckResult) {
        showLoading()
        GroupWorker.requestOutGroup(groupId: device.groupId ?? "") { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if responseCode == 200 {
                weakSelf.showMessage(title: "", content: "Gửi yêu cầu rời nhóm thành công!")
            } else {
                weakSelf.showError(title: "", content: result?.local_msg ?? "")
            }
        }
    }
    
    func configRefreshData() {
        tableView.addPullToRefresh { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
    }
    
    func refreshData() {
        if isViewLoaded {
            tableView.reloadData()
            if CacheManager.shared.getIsLogined() {
                guard let wspId = CacheManager.shared.getCurrentWorkspace()?.id else { return tableView.endRefreshing() }
                WorkspaceWorker.getStatistic(wspId: wspId, limit: timeType.rawValue) { [weak self] (result, error, responseCode) in
                    guard let weakSelf = self else { return }
                    if let model = result {
                        weakSelf.statisticModel = model
                    }
                    GroupWorker.list(wsid: wspId) { [weak self] (result, error, responseCode) in
                        guard let strongSelf = self else { return }
                        strongSelf.myGroups = result?.clients?.filter({ (m) -> Bool in
                            return m.isOwner == true
                        }) ?? []
                        strongSelf.inviteGroups = result?.clients?.filter({ (m) -> Bool in
                            return m.isOwner == false
                        }) ?? []
                        strongSelf.tableView.reloadData()
                        strongSelf.tableView.endRefreshing()
                        strongSelf.getCheckDevice()
                    }
                }
            } else {
                getCheckDevice()
            }
        }
    }
    
    func chooseTimeAction() {
        guard let view = ChooseTimeView.loadFromNib() else { return }
        view.chooseTimeAction = { [weak self] type in
            guard let weakSelf = self else { return }
            guard weakSelf.timeType != type else { return }
            weakSelf.timeType = type
            weakSelf.prepareData()
        }
        view.binding()
        showPopup(view: view)
    }
    
    func changeWorkspace() {
        guard let view = ListWorkspaceView.loadFromNib() else { return }
        view.loadView()
        view.selectedWorkspace = { [weak self] workspace in
            guard let weakSelf = self else { return }
            weakSelf.selectedWorkspace?(workspace)
            weakSelf.updateViewWithWsp(wsp: workspace)
            weakSelf.prepareData()
        }
        view.moreWorkspace = { [weak self] workspace in
            guard let weakSelf = self else { return }
            weakSelf.moreAction(workspace: workspace)
        }
        view.addWorkspace = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.showFormAddWorkspace()
        }
        showPopup(view: view)
    }
    
    func moreAction(workspace: WorkspaceModel) {
        guard let info = MoreActionView.loadFromNib() else { return }
        info.binding(title: workspace.name ?? "", type: .workspace)
        info.deleteAction = { [weak self] in
            guard let weakSelf = self else { return }
            if workspace.id == CacheManager.shared.getCurrentUser()?.defaultWorkspace {
                weakSelf.view.makeToast("Bạn không được phép xoá workspace mặc định")
                return
            }
            SwiftMessages.hide()
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.confirmDeleteWorkspace(sender:)), userInfo: workspace , repeats:false)
        }
        info.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.updateWorkspace(workspace: workspace)
        }
        showPopup(view: info)
    }
    
    @objc func confirmDeleteWorkspace(sender: Timer) {
        guard let workspace = sender.userInfo as? WorkspaceModel else { return }
        showConfirmDelete(title: "Bạn có chắc chắn muốn xoá workspace \(workspace.name ?? "") không?") { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.deleteWorkspace(workspace: workspace)
        }
    }
    
    func deleteWorkspace(workspace: WorkspaceModel) {
        showLoading()
        WorkspaceWorker.delete(wspId: workspace.id) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.updateWorkspaceWithDelete(id: workspace.id)
            weakSelf.prepareData()
        }
    }
    
    func updateWorkspaceWithDelete(id: String?) {
        if id == CacheManager.shared.getCurrentWorkspace()?.id {
            CacheManager.shared.setCurrentWorkspace(value: nil)
            let workspaces = CacheManager.shared.getWorkspacesResult() ?? []
            if workspaces.count > 0 {
                if let w = CacheManager.shared.getCurrentWorkspace() {
                    if let newValue = workspaces.filter({ (wm) -> Bool in
                        if wm.id == w.id { return true } else { return false }
                    }).first {
                        CacheManager.shared.setCurrentWorkspace(value: newValue)
                    }
                } else {
                    CacheManager.shared.setCurrentWorkspace(value: workspaces[0])
                }
            } else {
                CacheManager.shared.setCurrentWorkspace(value: nil)
            }
            tableView.reloadData()
        }
    }
    
    func updateWorkspace(workspace: WorkspaceModel) {
        let vc = PostWorkspacesVC(workspace: workspace, editMode: .update)
        vc.onUpdate = {
            self.refreshData()
        }
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}

extension GroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let isLogin = CacheManager.shared.getIsLogined()
        if isLogin {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isLogin = CacheManager.shared.getIsLogined()
        if isLogin {
            if section == 0 {
                return 1
            } else if section == 1 {
                return myGroups.count
            } else {
                return inviteGroups.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLogin = CacheManager.shared.getIsLogined()
        if isLogin {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkspaceSumaryCell.className) as? WorkspaceSumaryCell else {
                    return UITableViewCell()
                }
                cell.actionChooseTime = { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.chooseTimeAction()
                }
                cell.actionChangeWorkspace = { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.changeWorkspace()
                }
                cell.actionCreateGroup = { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.showFormAddGroup()
                }
                cell.actionJoinGroup = { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.joinGroup()
                }
                cell.bindingData(statistic: statisticModel, timeType: timeType)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.className) as? GroupCell else {
                    return UITableViewCell()
                }
                if indexPath.section == 1 {
                    cell.bindingData(group: myGroups[indexPath.row])
                    cell.onMoreAction = { [weak self] in
                        guard let weakSelf = self else { return }
                        weakSelf.showMoreAction(group: weakSelf.myGroups[indexPath.row])
                    }
                } else {
                    cell.bindingData(group: inviteGroups[indexPath.row])
                    cell.onMoreAction = { [weak self] in
                        guard let weakSelf = self else { return }
                        weakSelf.showMoreAction(group: weakSelf.inviteGroups[indexPath.row])
                    }
                }
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkspaceSumaryUnLoginCell.className) as? WorkspaceSumaryUnLoginCell else {
                return UITableViewCell()
            }
            cell.actionCreateGroup = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.login()
            }
            cell.actionJoinGroup = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.joinGroup()
            }
            cell.bindingData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let isLogin = CacheManager.shared.getIsLogined()
        if isLogin {
            if section == 1 {
                guard myGroups.count > 0 else { return UIView() }
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
                headerView.backgroundColor = UIColor.white
                let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: kScreenWidth-32, height: 44))
                titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                titleLabel.text = "Nhóm bạn quản lý"
                headerView.addSubview(titleLabel)
                return headerView
            } else if section == 2 {
                guard inviteGroups.count > 0 else { return UIView() }
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
                headerView.backgroundColor = UIColor.white
                let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: kScreenWidth-32, height: 44))
                titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                titleLabel.text = "Nhóm bạn đã tham gia"
                headerView.addSubview(titleLabel)
                return headerView
            }
            return UIView()
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let isLogin = CacheManager.shared.getIsLogined()
        if isLogin {
            if section == 1 {
                return myGroups.count > 0 ? 44 : 0.001
            } else if section == 2 {
                return inviteGroups.count > 0 ? 44 : 0.001
            }
            return 0.001
        } else {
            return 0.001
        }
    }
    
    func joinGroup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            let vc = ScanGroupVC()
            present(vc, animated: true, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    DispatchQueue.main.async {
                        let vc = ScanGroupVC()
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            fatalError()
        }
        
        
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Cập quyền truy cập",
                                      message: "Cập quyền truy cập Camera để thực hiện tính năng này?",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Hủy ", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Thiết lập", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        present(alertController, animated: true)
    }
    
    func login() {
        let vc = LoginVC()
        vc.onSuccess = {
            self.refreshData()
        }
        present(vc, animated: true)
    }
    
    func showMoreAction(group: GroupModel) {
        guard let view = MoreGroupActionView.loadFromNib() else { return }
        view.nameLabel.text = group.name
        view.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.editGroup(group: group)
        }
        view.deleteAction = { [weak self] in
            guard let weakSelf = self else { return }
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.deleteGroup(sender:)), userInfo: group , repeats:false)
        }
        showPopup(view: view)
    }
    
    func editGroup(group: GroupModel) {
        let vc = PostGroupVC(group: group)
        vc.onDone = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func deleteGroup(sender: Timer) {
        guard let group = sender.userInfo as? GroupModel else { return }
        showConfirmDelete(title: "Bạn có chắc chắn muốn xoá nhóm \(group.name ?? "") không?") { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.actionDeleteGroup(group: group)
        }
    }
    
    func actionDeleteGroup(group: GroupModel) {
        guard let groupId = group.groupid else { return }
        guard let userId = group.fkUserId else { return }
        showLoading()
        GroupWorker.delete(groupId: groupId, userId: userId) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.refreshData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            detailGroup(group: myGroups[indexPath.row])
        } else if indexPath.section == 2 {
            detailGroup(group: inviteGroups[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func detailGroup(group: GroupModel) {
        showLoading()
        GroupWorker.getGroup(id: group.groupid!) { (_group, error, responseCode) in
            self.hideLoading()
            let vc = GroupDetailVC(group: group)
            vc.updateGroup = { [weak self] in
                self?.refreshData()
            }
            vc.timeType = self.timeType
            vc.statisticModel = self.statisticModel
            let nav = BaseNavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
    }
}

extension GroupVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollDelegateFunc != nil {
            self.scrollDelegateFunc!(scrollView)
        }
    }
}
