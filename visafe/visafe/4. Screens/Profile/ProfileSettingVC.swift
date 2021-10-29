//
//  ProfileVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

public enum ProfileSettingEnum: Int {
    case changepass = 0
    case enterpin = 1
    case settingnoti = 2
    case language = 3
    
    func getIcon() -> UIImage? {
        switch self {
        case .changepass:
            return UIImage(named: "ic_changepass")
        case .enterpin:
            return UIImage(named: "ic_enterpin")
        case .settingnoti:
            return UIImage(named: "ic_noti")
        case .language:
            return UIImage(named: "ic_language")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .changepass:
            return "Đổi mật khẩu"
        case .enterpin:
            return CacheManager.shared.getPin() != nil ? "Cập nhật mã bảo vệ" : "Tạo mã bảo vệ"
        case .settingnoti:
            return "Cấu hình thông báo"
        case .language:
            return "Ngôn ngữ"
        }
    }
    
    func getContent() -> String {
        switch self {
        case .language:
            return "Tiếng Việt"
        default:
            return ""
        }
    }
}

class ProfileSettingVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sources: [ProfileSettingEnum] = (CacheManager.shared.getIsLogined() && CacheManager.shared.getCurrentUser()?.typeRegister == AccountTypeEnum.standard) ? [.changepass, .enterpin, .language] :  [.enterpin,  .language]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        title = "Cài đặt"
        tableView.registerCells(cells: [ProfileCell.className])
    }
}

extension ProfileSettingVC: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = sources[indexPath.row]
        switch type {
        case .changepass:
            changePass()
        case .enterpin:
            enterPin()
        case .settingnoti:
            notiSetting()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func changePass() {
        if checkLogin() {
            let vc = ChangePasswordNameVC()
            navigationController?.pushViewController(vc)
        }
    }
    
    func enterPin() {
        let vc = EnterPinVC()
        if CacheManager.shared.getPin() != nil {
            vc.screenType = .confirm
        }
        vc.onUpdate = {
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc)
    }

    func notiSetting() {
        let vc = NotiSettingVC()
        navigationController?.pushViewController(vc)
    }
    
    func checkLogin() -> Bool {
        if CacheManager.shared.getIsLogined() {
            return true
        } else {
            login()
            return false
        }
    }
    
    func login() {
        let vc = LoginVC()
        present(vc, animated: true)
    }
}

