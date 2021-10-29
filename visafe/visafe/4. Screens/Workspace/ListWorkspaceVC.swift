//
//  ListWorkspaceVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SwiftMessages

class ListWorkspaceVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var workspaces: [WorkspaceModel] = []
    var selectedWorkspace:((_ workspace: WorkspaceModel?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configBarButtonItem()
        configRefreshData()
        prepareData()
    }
    
    func configRefreshData() {
        tableView.addPullToRefresh { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
    }
    
    @objc func refreshData() {
        WorkspaceWorker.getList { [weak self] (list, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.tableView.endRefreshing()
            CacheManager.shared.setWorkspacesResult(value: list)
            weakSelf.loadData()
        }
    }
    
    @objc func prepareData() {
        showLoading()
        WorkspaceWorker.getList { [weak self] (list, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.tableView.endRefreshing()
            CacheManager.shared.setWorkspacesResult(value: list)
            weakSelf.loadData()
        }
    }
    
    func configView() {
        // title
        title = "Chọn Workspace"
        
        // tableview
        tableView.registerCells(cells: [WorkspaceCell.className])
        tableView.estimatedSectionHeaderHeight = 25
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: kNotificationUpdateWorkspace), object: nil)
    }
    
    func configBarButtonItem() {
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadData() {
        workspaces = CacheManager.shared.getWorkspacesResult() ?? []
        if workspaces.count > 0 {
            if let w = CacheManager.shared.getCurrentWorkspace() {
                if let newValue = workspaces.filter({ (wm) -> Bool in
                    if wm.id == w.id { return true } else { return false }
                }).first {
                    CacheManager.shared.setCurrentWorkspace(value: newValue)
                    selectedWorkspace?(newValue)
                }
            } else if let newValue = workspaces.filter({ (wm) -> Bool in
                if wm.id == CacheManager.shared.getCurrentUser()?.defaultWorkspace {
                    return true
                } else {
                    return false
                }
            }).first {
                CacheManager.shared.setCurrentWorkspace(value: newValue)
                selectedWorkspace?(newValue)
            } else {
                CacheManager.shared.setCurrentWorkspace(value: workspaces[0])
                selectedWorkspace?(workspaces[0])
            }
        } else {
            CacheManager.shared.setCurrentWorkspace(value: nil)
            selectedWorkspace?(nil)
        }
        tableView.reloadData()
    }
}

extension ListWorkspaceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workspaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkspaceCell.className) as? WorkspaceCell else {
            return UITableViewCell()
        }
        cell.binding(workspace: workspaces[indexPath.row])
        cell.moreAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.moreAction(workspace: weakSelf.workspaces[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CacheManager.shared.setCurrentWorkspace(value: workspaces[indexPath.row])
        selectedWorkspace?(workspaces[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = WorkspaceFooterView.loadFromNib()
        footerView?.actionAddWorkspace = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = PostWorkspacesVC(workspace: WorkspaceModel(), editMode: .add)
            let nav = BaseNavigationController(rootViewController: vc)
            weakSelf.present(nav, animated: true, completion: nil)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56.0
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
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.showConfirmDeleteworkspace(sender:)), userInfo: workspace , repeats:false)
        }
        info.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = PostWorkspacesVC(workspace: workspace, editMode: .update)
            let nav = BaseNavigationController(rootViewController: vc)
            weakSelf.present(nav, animated: true, completion: nil)
        }
        showPopup(view: info)
    }
    
    @objc func showConfirmDeleteworkspace(sender: Timer) {
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
            weakSelf.refreshData()
            weakSelf.removeCacheWorkspaceIfNeed(id: workspace.id)
        }
    }
    
    func removeCacheWorkspaceIfNeed(id: String?) {
        if id == CacheManager.shared.getCurrentWorkspace()?.id {
            CacheManager.shared.setCurrentWorkspace(value: nil)
        }
    }
}
