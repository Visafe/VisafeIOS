//
//  ProfileVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit
import SafariServices

public enum ProfileHelpEnum: Int {
    case question = 0
    case policy = 1
    case security = 2
    
    func getIcon() -> UIImage? {
        switch self {
        case .question:
            return UIImage(named: "ic_question")
        case .policy:
            return UIImage(named: "ic_policy")
        case .security:
            return UIImage(named: "ic_security")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .question:
            return "Câu hỏi thường gặp"
        case .policy:
            return "Điều khoản & Điều kiện"
        case .security:
            return "Chính sách bảo mật"
        }
    }
    
    func getUrlString() -> String {
        switch self {
        case .question:
            return "https://visafe.vn/faq"
        case .policy:
            return "https://visafe.vn/privacy"
        case .security:
            return "https://visafe.vn/security"
        }
    }
}

public enum ProfileHelpNowEnum: Int {
    case call = 0
    case email = 1
    case messenger = 2
    case facebook = 3
    
    func getIcon() -> UIImage? {
        switch self {
        case .call:
            return UIImage(named: "ic_calling")
        case .email:
            return UIImage(named: "ic_email")
        case .messenger:
            return UIImage(named: "ic_messenger")
        case .facebook:
            return UIImage(named: "ic_facebook_profile")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .call:
            return "Tổng đài CSKH"
        case .email:
            return "Email"
        case .messenger:
            return "Messenger"
        case .facebook:
            return "Facebook"
        }
    }
    
    func getContent() -> String {
        switch self {
        case .call:
            return "02432091616"
        case .email:
            return "ncsc@ais.gov.vn"
        case .messenger:
            return "m.me/govSOC"
        case .facebook:
            return "fb.com/govSOC"
        }
    }
}

class ProfileHelpVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sourcesHelp: [ProfileHelpEnum] = [.question, .policy, .security]
    var sourcesHelpNow: [ProfileHelpNowEnum] = [.call, .email, .messenger, .facebook]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func configView() {
        title = "Trung tâm hỗ trợ"
        tableView.registerCells(cells: [ProfileCell.className, ProfileHelpCell.className])
    }
}

extension ProfileHelpVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sourcesHelp.count
        } else {
            return sourcesHelpNow.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.className) as? ProfileCell else {
                return UITableViewCell()
            }
            cell.bindingData(type: sourcesHelp[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHelpCell.className) as? ProfileHelpCell else {
                return UITableViewCell()
            }
            cell.bindingData(type: sourcesHelpNow[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        headerView.backgroundColor = UIColor.white
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 6))
        lineView.backgroundColor = UIColor(hexString: "EEEEEE")
        headerView.addSubview(lineView)
        
        let label = UILabel(frame: CGRect(x: 16, y: 18, width: kScreenWidth, height: 32))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        if section == 0 {
            label.text = "Điều khoản và chính sách"
        } else {
            label.text = "Bạn cần hỗ trợ ngay"
        }
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            showUrl(urlString: sourcesHelp[indexPath.row].getUrlString())
        } else {
            showHelpNow(type: sourcesHelpNow[indexPath.row])
        }
    }
    
    func showUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func showHelpNow(type: ProfileHelpNowEnum) {
        switch type {
        case .call:
            showPhoneTell(tel: type.getContent())
        case .facebook:
            showLinkFb(fb: type.getContent())
        case .messenger:
            showLinkMessager(mes: type.getContent())
        case .email:
            showMail(mail: type.getContent())
        }
    }
    
    func showPhoneTell(tel: String) {
        if let url = URL(string: "tel:\(tel)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showLinkFb(fb: String) {
        if let url = URL(string: "https://www.fb.com/govSOC") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showLinkMessager(mes: String) {
        if let url = URL(string: "https://www.m.me/govSOC") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showMail(mail: String) {
        if let url = URL(string: "mailto:\(mail)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

