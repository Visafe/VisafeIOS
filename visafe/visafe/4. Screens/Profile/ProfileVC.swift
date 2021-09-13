//
//  ProfileVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit
import StoreKit

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
    
    var sources: [ProfileEnum] = CacheManager.shared.getIsLogined() ? [.upgradeAccount, .setting, .help, .share, .rate, .logout] : [.upgradeAccount, .setting, .help, .share, .rate]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: kLoginSuccess), object: nil)
        configView()
    }
    
    @objc func refreshData() {
        guard isViewLoaded else { return }
        sources = CacheManager.shared.getIsLogined() ? [.upgradeAccount, .setting, .help, .share, .rate, .logout] : [.upgradeAccount, .setting, .help, .share, .rate]
        tableView.reloadData()
    }
    
    func configView() {
        title = "Tài khoản"
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 25
        tableView.registerCells(cells: [ProfileCell.className])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthenWorker.profile { [weak self] (user, error) in
            guard let weakSelf = self else { return }
            CacheManager.shared.setCurrentUser(value: user)
            weakSelf.tableView.reloadData()
        }
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
        case .upgradeAccount:
            if CacheManager.shared.getIsLogined() {
                showLicenseInfo()
            } else {
                showLicense()
            }
        case .share:
            shareApp()
        case .rate:
            rateApp()
        }
    }
    
    func showLicenseInfo() {
        let vc = LicenseInfoVC()
        vc.morePackage = { [weak self] in
            self?.showLicense()
        }
        vc.workspace = { [weak self] in
            self?.chooseWorkspace()
        }
        present(vc, animated: true)
    }
    
    func checkLogin() -> Bool {
        if CacheManager.shared.getIsLogined() {
            return true
        } else {
            login()
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = ProfileFooterView.loadFromNib()
        footerView?.bindingData()
        footerView?.upgrade = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.showLicense()
        }
        footerView?.register = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.login()
        }
        return footerView
    }
    
    func login() {
        let vc = LoginVC()
        vc.onSuccess = {
            self.tableView.reloadData()
        }
        present(vc, animated: true)
    }
    
    func chooseWorkspace() {
        if checkLogin() {
            let vc = ListWorkspaceVC()
            let nav = BaseNavigationController(rootViewController: vc)
            present(nav, animated: true)
        }
    }
    
    func showSetting() {
        let vc = ProfileSettingVC()
        navigationController?.pushViewController(vc)
        
    }
    
    func showHelp() {
        let vc = ProfileHelpVC()
        navigationController?.pushViewController(vc)
    }
    
    func showLicense() {
        if checkLogin() {
            let vc = LicenseOverviewVC()
            vc.paymentSuccess = { [weak self] in
                self?.paymentSuccess()
            }
            present(vc, animated: true)
        }
    }
    
    func paymentSuccess() {
        AuthenWorker.profile { [weak self] (user, error) in
            guard let weakSelf = self else { return }
            if let u = user {
                CacheManager.shared.setCurrentUser(value: u)
                weakSelf.tableView.reloadData()
            }
        }
    }
    
    func logout() {
        showConfirmDelete(title: "Bạn có chắc chắn muốn đăng xuất không?") {
            CacheManager.shared.setIsLogined(value: false)
            CacheManager.shared.removeCurrentUser()
            CacheManager.shared.setCurrentWorkspace(value: nil)
            CacheManager.shared.setPin(value: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoginSuccess), object: nil)
        }
    }
    
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
    func shareApp() {
        let activity = UIActivityViewController(activityItems: [URL(string: "https://apps.apple.com/vn/app/visafe/id1564635388")!],applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
}

