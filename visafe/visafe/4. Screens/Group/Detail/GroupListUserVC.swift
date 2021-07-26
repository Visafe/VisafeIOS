//
//  GroupListUserVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

class GroupListUserVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var group: GroupModel
    
    var listUser: [UserModel] = []
    
    init(group: GroupModel) {
        self.group = group
        listUser = group.usersGroupInfo
        super.init(nibName: GroupListUserVC.className, bundle: nil)
    }
    
    func updateData() {
        for item in listUser {
            guard let userId = item.userid?.int else { continue }
            if item.userid?.int == group.fkUserId {
                item.role = .owner
            }
            if group.userManage.contains(where: { (id) -> Bool in
                if (id == userId.string) { return true } else { return false }
            }) {
                item.role = .admin
            }
            if group.usersActive.contains(where: { (id) -> Bool in
                if (id == userId.string) { return true } else { return false }
            }) {
                item.role = .suppervisor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quản lý thành viên"
        tableView.registerCells(cells: [GroupMemberCell.className])
        updateData()
        tableView.reloadData()
    }
}

extension GroupListUserVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupMemberCell.className) as? GroupMemberCell else {
            return UITableViewCell()
        }
        let user = listUser[indexPath.row]
        cell.binding(user: user)
        cell.moreAction = { [weak self] in
            guard let weaSelf = self else { return }
            weaSelf.moreAction(user: user)
        }
        return cell
    }
    
    func moreAction(user: UserModel) {
        guard let view = MoreActionMemberView.loadFromNib() else { return }
        view.binding(user: user)
        view.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.editUser(user: user)
        }
        view.deleteAction = { [weak self] in
            guard let weakSelf = self else { return }
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.deleteUserAction(sender:)), userInfo: user , repeats:false)
        }
        showPopup(view: view)
    }
    
    @objc func deleteUserAction(sender: Timer) {
        guard let user = sender.userInfo as? UserModel else { return }
        let title = "Bạn có chắc chắn muốn xóa thành viên \(user.fullname ?? "") khỏi nhóm?"
        showConfirmDelete(title: title) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.deleteUser(user: user)
        }
    }
    
    func deleteUser(user: UserModel) {
        showLoading()
        GroupWorker.groupDeleteUser(userId: user.userid?.int, groupId: group.groupid) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            for index in 0..<weakSelf.listUser.count {
                let item = weakSelf.listUser[index]
                if item.userid == user.userid {
                    weakSelf.listUser.remove(at: index)
                    break
                }
            }
            weakSelf.tableView.reloadData()
        }
    }
    
    func editUser(user: UserModel) {
        if user.role == .member || user.role == .suppervisor {
            makeManagerRole(user: user)
        } else {
            makeViewerRole(user: user)
        }
    }
    
    func makeManagerRole(user: UserModel) {
        showLoading()
        GroupWorker.groupUserManager(userId: user.userid?.int, groupId: group.groupid) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            user.role = .admin
            weakSelf.tableView.reloadData()
        }
    }
    
    func makeViewerRole(user: UserModel) {
        showLoading()
        GroupWorker.groupUserViewer(userId: user.userid?.int, groupId: group.groupid) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            user.role = .suppervisor
            weakSelf.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if listUser.count == 0 { return UIView() }
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
        viewHeader.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 16, y: 6, width: kScreenWidth - 32, height: 48))
        label.text = "\(listUser.count) thành viên"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        viewHeader.addSubview(label)
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if listUser.count == 0 { return 0.0001 }
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
