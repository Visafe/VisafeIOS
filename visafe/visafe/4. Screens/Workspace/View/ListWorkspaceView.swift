//
//  ListWorkspaceView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SwiftMessages

class ListWorkspaceView: MessageView {

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
        WorkspaceWorker.getList { [weak self] (list, error) in
            guard let weakSelf = self else { return }
            weakSelf.tableView.endRefreshing()
            CacheManager.shared.setWorkspacesResult(value: list)
            weakSelf.loadData()
        }
    }
    
    @objc func prepareData() {
        WorkspaceWorker.getList { [weak self] (list, error) in
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
    
    func load() {
        var view = UILabel()

        view.frame = CGRect(x: 0, y: 0, width: 343, height: 192)

        view.backgroundColor = .white


        var shadows = UIView()

        shadows.frame = view.frame

        shadows.clipsToBounds = false

        view.addSubview(shadows)


        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 16)

        let layer0 = CALayer()

        layer0.shadowPath = shadowPath0.cgPath

        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor

        layer0.shadowOpacity = 1

        layer0.shadowRadius = 32

        layer0.shadowOffset = CGSize(width: 0, height: 12)

        layer0.bounds = shadows.bounds

        layer0.position = shadows.center

        shadows.layer.addSublayer(layer0)


        var shapes = UIView()

        shapes.frame = view.frame

        shapes.clipsToBounds = true

        view.addSubview(shapes)


        let layer1 = CALayer()

        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        layer1.bounds = shapes.bounds

        layer1.position = shapes.center

        shapes.layer.addSublayer(layer1)


        shapes.layer.cornerRadius = 16
    }
}
