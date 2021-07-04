//
//  ConfigVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit

class ConfigVC: BaseViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    var workspace: WorkspaceModel = CacheManager.shared.getCurrentWorkspace() ?? WorkspaceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        configRefreshData()
    }
    
    func registerTableView() {
        tableView.registerCells(cells: [SecurityWorkspaceCell.className])
    }
    
    func configRefreshData() {
        tableView.addPullToRefresh { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
    }
    
    func refreshData() {
        if isViewLoaded {
            workspace = CacheManager.shared.getCurrentWorkspace() ?? WorkspaceModel()
            tableView.reloadData { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.tableView.endRefreshing()
            }
        }
    }
}

extension ConfigVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SecurityWorkspaceEnum.getAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SecurityWorkspaceCell.className) as? SecurityWorkspaceCell else {
            return UITableViewCell()
        }
        let type = SecurityWorkspaceEnum.getAll()[indexPath.row]
        cell.bindingData(workspace: workspace, type: type)
        cell.onChangeSwitch = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.updateWorkspace(type: type, index: indexPath)
        }
        return cell
    }
    
    func updateWorkspace(type: SecurityWorkspaceEnum, index: IndexPath) {
        showLoading()
        WorkspaceWorker.update(workspace: workspace) { [weak self] (model, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if let m = model { // cập nhật thành công
                CacheManager.shared.setCurrentWorkspace(value: m)
            } else { // cập nhật thất bại
                guard let cell = weakSelf.tableView.cellForRow(at: index) as? SecurityWorkspaceCell else { return }
                cell.checkSwitch.isOn = !cell.checkSwitch.isOn
                switch type {
                case .log:
                    weakSelf.workspace.logEnabled = cell.checkSwitch.isOn
                case .malware:
                    weakSelf.workspace.malwareEnabled = cell.checkSwitch.isOn
                case .phishing:
                    weakSelf.workspace.phishingEnabled = cell.checkSwitch.isOn
                }
            }
        }
    }
}
