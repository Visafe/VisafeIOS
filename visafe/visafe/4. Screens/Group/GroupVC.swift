//
//  GroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit

class GroupVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var myGroups: [GroupModel] = []
    var inviteGroups: [GroupModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshData()
        configView()
        prepareData()
    }
    
    func configView() {
        // tableview
        tableView.registerCells(cells: [GroupCell.className])
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: kScreenWidth*180/375-54, left: 0, bottom: 0, right: 0)
        
        //create view as header view
        guard let headerView = GroupHeaderView.loadFromNib() else { return }
        headerView.addGroupAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.showFormAddGroup()
        }
        tableView.tableHeaderView = headerView
    }
    
    func showFormAddGroup() {
        let vc = PostGroupAboutVC()
        vc.startAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.postGroup()
        }
        present(vc, animated: true, completion: nil)
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
        showLoading()
        let workspace = CacheManager.shared.getCurrentWorkspace()
        GroupWorker.list(wsid: workspace?.id) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.myGroups = result?.clients?.filter({ (m) -> Bool in
                return m.isOwner == true
            }) ?? []
            weakSelf.inviteGroups = result?.clients?.filter({ (m) -> Bool in
                return m.isOwner == false
            }) ?? []
            weakSelf.tableView.reloadData()
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
            let workspace = CacheManager.shared.getCurrentWorkspace()
            GroupWorker.list(wsid: workspace?.id) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.myGroups = result?.clients?.filter({ (m) -> Bool in
                    return m.isOwner == true
                }) ?? []
                weakSelf.inviteGroups = result?.clients?.filter({ (m) -> Bool in
                    return m.isOwner == false
                }) ?? []
                weakSelf.tableView.reloadData()
                weakSelf.tableView.endRefreshing()
            }
        }
    }
}

extension GroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myGroups.count
        } else {
            return inviteGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.className) as? GroupCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard myGroups.count > 0 else { return UIView() }
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
            headerView.backgroundColor = UIColor.white
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: kScreenWidth-32, height: 44))
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.text = "Nhóm bạn quản lý"
            headerView.addSubview(titleLabel)
            return headerView
        } else {
            guard inviteGroups.count > 0 else { return UIView() }
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
            headerView.backgroundColor = UIColor.white
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: kScreenWidth-32, height: 44))
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.text = "Nhóm bạn đã tham gia"
            headerView.addSubview(titleLabel)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return myGroups.count > 0 ? 44 : 0.001
        } else {
            return inviteGroups.count > 0 ? 44 : 0.001
        }
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
        GroupWorker.delete(groupId: groupId, userId: userId) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.refreshData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            detailGroup(group: myGroups[indexPath.row])
        } else {
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
        let vc = GroupDetailVC(group: group)
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

