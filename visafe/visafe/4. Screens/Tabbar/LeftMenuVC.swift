//
//  LeftMenuVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SwiftMessages

class LeftMenuVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var workspaces: [WorkspaceModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        prepareData()
    }
    
    @objc func refreshData() {
        WorkspaceWorker.getList { [weak self] (list, error) in
            guard let weakSelf = self else { return }
            CacheManager.shared.setWorkspacesResult(value: list)
            weakSelf.prepareData()
        }
    }
    
    func configView() {
        // tableview
        tableView.registerCells(cells: [WorkspaceCell.className])
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: kNotificationUpdateWorkspace), object: nil)
    }
    
    func prepareData() {
        workspaces = CacheManager.shared.getWorkspacesResult() ?? []
        tableView.reloadData()
    }
}

extension LeftMenuVC: UITableViewDelegate, UITableViewDataSource {
    
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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = WorkspaceFooterView.loadFromNib()
        footerView?.actionAddWorkspace = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = PostWorkspaceVC()
            let nav = BaseNavigationController(rootViewController: vc)
            weakSelf.sideMenuController?.hideMenu()
            weakSelf.present(nav, animated: true, completion: nil)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 230
    }
    
    func moreAction(workspace: WorkspaceModel) {
        guard let info = MoreActionWorkspaceView.loadFromNib() else { return }
        info.binding(workspaceName: workspace.name)
        info.deleteAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.showConfirmDeleteworkspace(workspace: workspace)
        }
        info.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.sideMenuController?.hideMenu()
            let vc = PostWorkspaceVC(workspace: workspace)
            let nav = BaseNavigationController(rootViewController: vc)
            weakSelf.present(nav, animated: true, completion: nil)
        }
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .bottom
        infoConfig.duration = .forever
        infoConfig.dimMode = .blur(style: .dark, alpha: 0.2, interactive: true)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    @objc func showConfirmDeleteworkspace(workspace: WorkspaceModel) {
        guard let info = ConfirmDeleteWorkspaceView.loadFromNib() else { return }
        info.acceptAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.deleteWorkspace(workspace: workspace)
        }
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .bottom
        infoConfig.duration = .forever
        infoConfig.dimMode = .blur(style: .dark, alpha: 0.2, interactive: true)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func deleteWorkspace(workspace: WorkspaceModel) {
        showLoading()
        WorkspaceWorker.delete(wspId: workspace.id) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.refreshData()
        }
    }
}
