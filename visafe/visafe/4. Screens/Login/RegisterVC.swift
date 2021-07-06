//
//  RegisterVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import SwiftMessages

class RegisterVC: BaseViewController {

    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var usernameInfoLabel: UILabel!
    @IBOutlet weak var usernameTextfield: BaseTextField!
    @IBOutlet weak var passwordTextfield: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if validateInfo() {
            register()
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let username = usernameTextfield.text ?? ""
        if username.isEmpty {
            success = false
            usernameInfoLabel.text = "Tên đăng nhập không được để trống"
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            usernameInfoLabel.text = "Tên đăng nhập không đúng định dạng"
        } else {
            usernameInfoLabel.text = nil
        }
        let password = passwordTextfield.text ?? ""
        if password.isEmpty {
            success = false
            passwordInfoLabel.text = "Mật khẩu không được để trống"
        } else {
            passwordInfoLabel.text = nil
        }
        return success
    }
    
    func register() {
        let param = RegisterParam()
        let username = usernameTextfield.text ?? "0"
        if username.isValidEmail {
            param.email = username
        } else {
            param.phone_number = "84" + username.dropFirst()
        }
        param.full_name = usernameTextfield.text
        param.password = passwordTextfield.text
        param.repeat_password = passwordTextfield.text
        showLoading()
        AuthenWorker.register(param: param) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.handleRegisterResult(result: result, error: error)
        }
    }
    
    func handleRegisterResult(result: ResgisterResult?, error: Error?) {
        if result?.status_code == .successWithEmail || result?.status_code == .successWithPhone {
            let model = PasswordModel()
            let username = usernameTextfield.text ?? "0"
            if username.isValidEmail {
                model.email = username
            } else {
                model.phone_number = "84" + username.dropFirst()
            }
            model.password = passwordTextfield.text
            let vc = EnterOTPVC(model: model, type: .activeAccount)
            navigationController?.pushViewController(vc)
        } else {
            let errorCode = result?.status_code ?? .error
            showError(title: "Đăng ký không thành công", content: errorCode.getDescription())
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterVC: UITextFieldDelegate {
    
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
