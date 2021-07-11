//
//  ProfileVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

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
            return "(+84) 24 3209 1616"
        case .email:
            return "ncsc@ais.gov.vn"
        case .messenger:
            return "fb.com/govSOC"
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
    }
}

