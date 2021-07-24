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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quản lý thành viên"
        tableView.registerCells(cells: [GroupMemberCell.className])
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
        user.isOwner = (group.fkUserId == CacheManager.shared.getCurrentUser()?.userid)
        cell.binding(user: user)
        return cell
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
