//
//  ChangePasswordNameVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit

class ChangePasswordNameVC: BaseViewController {
    
    @IBOutlet weak var passTextfield: BaseTextField!
    @IBOutlet weak var desctiptionLabel: UILabel!
    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Đổi mật khẩu"
        if let user = CacheManager.shared.getCurrentUser() {
            desctiptionLabel.text = "Hãy nhập mật khẩu cho tài khoản \n \(user.phonenumber ?? user.email ?? "")"
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validateInfo() {
            let param = ChangePassParam()
            param.currentPassword = passTextfield.text
            let vc = ChangePasswordVC(param: param)
            navigationController?.pushViewController(vc)
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let oldPassword = passTextfield.text ?? ""
        if oldPassword.isEmpty {
            success = false
            passwordInfoLabel.text = "Mật khẩu cũ không được để trống"
        } else {
            passwordInfoLabel.text = nil
        }
        return success
    }
}

extension ChangePasswordNameVC: UITextFieldDelegate {
    
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
