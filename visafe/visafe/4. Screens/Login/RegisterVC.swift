//
//  RegisterVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import TweeTextField
import SwiftMessages

class RegisterVC: BaseViewController {

    @IBOutlet weak var passwordTextfield: TweeAttributedTextField!
    @IBOutlet weak var usernameTextfield: TweeAttributedTextField!
    @IBOutlet weak var rePasswordTextfield: TweeAttributedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .done, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @IBAction func editingEnd(_ sender: Any) {
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
            usernameTextfield.showInfo("Username không được để trống")
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            usernameTextfield.showInfo("Username không đúng định dạng")
        } else {
            usernameTextfield.hideInfo()
        }
        let password = passwordTextfield.text ?? ""
        if password.isEmpty {
            success = false
            passwordTextfield.showInfo("Mật khẩu không được để trống")
        } else {
            passwordTextfield.hideInfo()
        }
        let repassword = rePasswordTextfield.text ?? ""
        if repassword.isEmpty {
            success = false
            rePasswordTextfield.showInfo("Mật khẩu không được để trống")
        } else {
            rePasswordTextfield.hideInfo()
        }
        if !password.isEmpty && !repassword.isEmpty && password != repassword {
            passwordTextfield.showInfo("Mật khẩu không trùng nhau")
            rePasswordTextfield.showInfo("Mật khẩu không trùng nhau")
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
        param.repeat_password = rePasswordTextfield.text
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
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}
