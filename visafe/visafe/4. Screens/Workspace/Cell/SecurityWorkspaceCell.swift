//
//  SecurityWorkspaceCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit

public enum SecurityWorkspaceEnum: Int {
    case phishing = 1
    case malware = 2
    case log = 3
    
    func getIcon() -> UIImage? {
        switch self {
        case .phishing:
            return UIImage(named: "anonymous_icon")
        case .malware:
            return UIImage(named: "bug_icon")
        case .log:
            return UIImage(named: "repeat_icon")
        }
    }
    
    func getTitle() -> String? {
        switch self {
        case .phishing:
            return "Chống lừa đảo mạng"
        case .malware:
            return "Chống mã độc & tấn công mạng"
        case .log:
            return "Lưu trữ lịch sử truy cập"
        }
    }
    
    func getContent() -> String? {
        switch self {
        case .phishing:
            return "Ngăn chặn & cảnh báo khi người dùng truy cập vào các trang web, ứng dụng có dấu hiệu lừa đảo"
        case .malware:
            return "Chống tấn công mã độc, phần mềm tống tiền, tấn công mạng,..."
        case .log:
            return "Thống kê năng suất học tập/làm việc, thời gian sử dụng"
        }
    }
    
    static func getAll() -> [SecurityWorkspaceEnum] {
        return [.phishing, .malware, .log]
    }
}

class SecurityWorkspaceCell: BaseTableCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var checkSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var onChangeSwitch:(() -> Void)?
    var type: SecurityWorkspaceEnum?
    var workspace: WorkspaceModel?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(workspace: WorkspaceModel, type: SecurityWorkspaceEnum) {
        avatarImage.image = type.getIcon()
        titleLabel.text = type.getTitle()
        contentLabel.text = type.getContent()
        updateStateSwitch(workspace: workspace, type: type)
    }
    
    func updateStateSwitch(workspace: WorkspaceModel, type: SecurityWorkspaceEnum) {
        self.workspace = workspace
        self.type = type
        switch type {
        case .phishing:
            checkSwitch.isOn = workspace.phishingEnabled ?? false
        case .malware:
            checkSwitch.isOn = workspace.malwareEnabled ?? false
        case .log:
            checkSwitch.isOn = workspace.logEnabled ?? false
        }
    }
    
    @IBAction func valueChange(_ sender: UISwitch) {
        guard let type = self.type else { return }
        switch type {
        case .phishing:
            workspace?.phishingEnabled = sender.isOn
        case .malware:
            workspace?.malwareEnabled = sender.isOn
        case .log:
            workspace?.logEnabled = sender.isOn
        }
        onChangeSwitch?()
    }
}
