//
//  ListWorkspaceView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SwiftMessages

class ListWorkspaceView: MessageViewBase {

    @IBOutlet weak var tableView: UITableView!
    
    var workspaces: [WorkspaceModel] = []
    var selectedWorkspace:((_ workspace: WorkspaceModel?) -> Void)?
    var moreWorkspace:((_ workspace: WorkspaceModel) -> Void)?
    var addWorkspace:(() -> Void)?
    
    class func loadFromNib() -> ListWorkspaceView? {
        return self.loadFromNib(withName: ListWorkspaceView.className)
    }
    
    func loadView() {
        configView()
        loadData()
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
        WorkspaceWorker.getList { [weak self] (list, error, responseCode) in
            guard let weakSelf = self else { return }
            CacheManager.shared.setWorkspacesResult(value: list)
            weakSelf.loadData()
        }
    }
    
    func configView() {
        // tableview
        tableView.registerCells(cells: [WorkspaceCell.className])
        tableView.estimatedSectionHeaderHeight = 25
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    func loadData() {
        workspaces = CacheManager.shared.getWorkspacesResult() ?? []
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
        }
        tableView.reloadData()
    }
}

extension ListWorkspaceView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workspaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkspaceCell.className) as? WorkspaceCell else {
            return UITableViewCell()
        }
        let workspace = workspaces[indexPath.row]
        cell.binding(workspace: workspace)
        cell.moreAction = { [weak self] in
            guard let weakSelf = self else { return }
            SwiftMessages.hide()
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.moreAction(sender:)), userInfo: workspace , repeats:false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CacheManager.shared.setCurrentWorkspace(value: workspaces[indexPath.row])
        selectedWorkspace?(workspaces[indexPath.row])
        SwiftMessages.hide()
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
            SwiftMessages.hide()
            weakSelf.addWorkspace?()
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56.0
    }
    
    @objc func moreAction(sender: Timer) {
        guard let workspace = sender.userInfo as? WorkspaceModel else { return }
        moreWorkspace?(workspace)
    }
}
