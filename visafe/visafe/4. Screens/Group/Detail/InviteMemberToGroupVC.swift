//
//  InviteMemberToGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit

class InviteMemberToGroupVC: BaseViewController {
    
    @IBOutlet weak var descriptionNameLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameTextfield: BaseTextField!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var group: GroupModel
    
    var onDone:((_ user: UserModel) -> Void)?
    
    init(group: GroupModel) {
        self.group = group
        super.init(nibName: InviteMemberToGroupVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        updateStateButtonContinue()
        
        // title
        title = "Thêm thành viên"
        groupNameLabel.text = group.name
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if validateInfo() {
            let param = InviteToGroupParam()
            let username = nameTextfield.text ?? "0"
            var name = ""
            if username.isValidEmail { // email
                name = username
            } else { // sdt
                if username.starts(with: "84") {
                    name = username
                } else {
                    name = "84" + username.dropFirst()
                }
            }
            param.groupID = group.groupid
            param.usernames = [name]
            showLoading()
            GroupWorker.inviteToGroup(param: param) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                if let user = result?.invited?.first {
                    weakSelf.onDone?(user)
                    weakSelf.navigationController?.popViewController()
                } else {
                    weakSelf.showError(title: "Thêm thành viên không thành công", content: result?.local_msg ?? "")
                }
            }
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let username = nameTextfield.text ?? ""
        if username.isEmpty {
            success = false
            descriptionNameLabel.text = "Số điện thoại hoặc email không được để trống"
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            descriptionNameLabel.text = "Số điện thoại hoặc email không không đúng định dạng"
        }
        return success
    }
    
    func updateStateButtonContinue() {
        if (nameTextfield.text?.count ?? 0) == 0 {
            continueButton.backgroundColor = UIColor(hexString: "F8F8F8")
            continueButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
            continueButton.isUserInteractionEnabled = false
        } else {
            continueButton.backgroundColor = UIColor.mainColorOrange()
            continueButton.setTitleColor(UIColor.white, for: .normal)
            continueButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func valueChanged(_ sender: BaseTextField) {
        updateStateButtonContinue()
    }
}


extension InviteMemberToGroupVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let field = textField as? BaseTextField else { return }
        if field.type != .error {
            field.setState(type: .active)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = textField as? BaseTextField else { return }
        if field.type != .error {
            field.setState(type: .normal)
        }
    }
}
