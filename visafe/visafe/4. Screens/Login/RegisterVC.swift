//
//  RegisterVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import TweeTextField

class RegisterVC: BaseViewController {

    @IBOutlet weak var passwordTextfield: TweeAttributedTextField!
    @IBOutlet weak var emailTextfield: TweeAttributedTextField!
    @IBOutlet weak var rePasswordTextfield: TweeAttributedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editingEnd(_ sender: Any) {
        _ = validateInfo()
    }
    
    
    @IBAction func registerAction(_ sender: Any) {
        if validateInfo() {
            register()
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let email = emailTextfield.text ?? ""
        if email.isEmpty {
            success = false
            emailTextfield.showInfo("Email không được để trống")
        } else if !email.isValidEmail {
            success = false
            emailTextfield.showInfo("Email không đúng định dạng")
        } else {
            emailTextfield.hideInfo()
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
        param.username = emailTextfield.text
        param.email = emailTextfield.text
        param.password = passwordTextfield.text
        param.passwordagain = rePasswordTextfield.text
        showLoading()
        AuthenWorker.register(param: param) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
