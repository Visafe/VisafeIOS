//
//  ChangePasswordVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit

class ChangePasswordVC: BaseViewController {
    
    @IBOutlet weak var passwordTextfield: BaseTextField!
    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var rePasswordTextfield: BaseTextField!
    @IBOutlet weak var rePasswordInfoLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var param = ChangePassParam()
    
    init(param: ChangePassParam) {
        self.param = param
        super.init(nibName: ChangePasswordVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Đổi mật khẩu"
        if let user = CacheManager.shared.getCurrentUser() {
            descriptionLabel.text = "Hãy nhập mật khẩu cho tài khoản \n \(user.phonenumber ?? user.email ?? "")"
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validateInfo() {
            param.newPassword = passwordTextfield.text
            param.repeatPassword = rePasswordTextfield.text
            showLoading()
            AuthenWorker.changePassword(param: param) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(result: result, error: error)
            }
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let password = passwordTextfield.text ?? ""
        if password.isEmpty {
            success = false
            passwordInfoLabel.text = "Mật khẩu không được để trống"
        } else {
            passwordInfoLabel.text = nil
        }
        let repassword = rePasswordTextfield.text ?? ""
        if repassword.isEmpty {
            success = false
            rePasswordInfoLabel.text = "Mật khẩu không được để trống"
        } else {
            rePasswordInfoLabel.text = nil
        }
        if !password.isEmpty && !repassword.isEmpty && password != repassword {
            passwordInfoLabel.text = "Mật khẩu không trùng nhau"
            rePasswordInfoLabel.text = "Mật khẩu không trùng nhau"
        }
        return success
    }
    
    func handleResponse(result: ChangePasswordResult?, error: Error?) {
        if result == nil && error == nil {
            showMessage(title: "Đổi mật khẩu thành công", content: "Visafe đã sẵn sàng bảo vệ bạn") { [weak self] in
                guard let weakSelf = self else { return }
                for controller in (weakSelf.navigationController!.viewControllers) {
                    if controller.isKind(of: ProfileSettingVC.self) {
                        _ =  weakSelf.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        } else if let res = result {
            showError(title: "Đổi mật khẩu lỗi", content: res.status_code?.getDescription())
        }
    }
}

extension ChangePasswordVC: UITextFieldDelegate {
    
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
