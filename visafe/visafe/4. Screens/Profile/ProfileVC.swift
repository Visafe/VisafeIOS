//
//  ProfileVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

public enum ProfileEnum: Int {
    case accountType = 0
    case upgradeAccount = 1
    case setting = 2
    case help = 3
    case share = 4
    case rate = 5
    case logout = 6
    
    func getIcon() -> UIImage? {
        switch self {
        case .accountType:
            return UIImage(named: "ic_accounttype")
        case .upgradeAccount:
            return UIImage(named: "ic_upgradeaccount")
        case .setting:
            return UIImage(named: "ic_setting")
        case .help:
            return UIImage(named: "ic_helprofile")
        case .share:
            return UIImage(named: "ic_share")
        case .rate:
            return UIImage(named: "ic_rate")
        case .logout:
            return UIImage(named: "ic_logout")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .accountType:
            return "Loại tài khoản"
        case .upgradeAccount:
            return "Nâng cấp gói"
        case .setting:
            return "Cài đặt"
        case .help:
            return "Trung tâm trợ giúp"
        case .share:
            return "Chia sẻ ứng dụng"
        case .rate:
            return "Đánh giá ứng dụng"
        case .logout:
            return "Đăng xuất"
        }
    }
    
    func getContent() -> String {
        switch self {
        case .accountType:
            return CacheManager.shared.getCurrentWorkspace()?.name ?? "Gia đình & nhóm"
        case .upgradeAccount:
            return "Basic"
        case .setting:
            return "Mật khẩu & bảo mật"
        default:
            return ""
        }
    }
    
    func getFoooterLineHeight() -> CGFloat {
        switch self {
        case .rate:
            return 6
        default:
            return 0.5
        }
    }
}

class ProfileVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sources: [ProfileEnum] = [.accountType, .upgradeAccount, .setting, .help, .share, .rate, .logout]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        title = "Tài khoản"
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 25
        tableView.registerCells(cells: [ProfileCell.className])
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.className) as? ProfileCell else {
            return UITableViewCell()
        }
        cell.bindingData(type: sources[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileHeaderView.loadFromNib()
        headerView?.actionLogin = {  [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.login()
        }
        headerView?.bindingData()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = sources[indexPath.row]
        switch type {
        case .accountType:
            chooseWorkspace()
        case .setting:
            showSetting()
        case .help:
            showHelp()
        case .logout:
            logout()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = ProfileFooterView.loadFromNib()
        return footerView
    }
    
    func login() {
        let vc = LoginVC()
        present(vc, animated: true)
    }
    
    func chooseWorkspace() {
        let vc = ListWorkspaceVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    func showSetting() {
        let vc = ProfileSettingVC()
        navigationController?.pushViewController(vc)
        
    }
    
    func showHelp() {
        let vc = ProfileHelpVC()
        navigationController?.pushViewController(vc)
    }
    
    func logout() {
        showConfirmDelete(title: "Bạn có chắc chắn muốn đăng xuất không?") {
            CacheManager.shared.setIsLogined(value: false)
            CacheManager.shared.setCurrentUser(value: nil)
            CacheManager.shared.setCurrentWorkspace(value: nil)
            AppDelegate.appDelegate()?.configRootVC()
        }
    }
}

