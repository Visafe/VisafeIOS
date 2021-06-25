//
//  LoginVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import TweeTextField
import SwifterSwift

class LoginVC: BaseViewController {

    @IBOutlet weak var emailTextfield: TweeAttributedTextField!
    @IBOutlet weak var passwordTextfield: TweeAttributedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func regiterAction(_ sender: Any) {
        let registerVC = RegisterVC()
        present(registerVC, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if validate() {
            showLoading()
            let loginParam = LoginParam()
            loginParam.email = emailTextfield.text
            loginParam.password = passwordTextfield.text
            AuthenWorker.login(param: loginParam) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                
            }
        }
    }
    
    @IBAction func endEditing(_ sender: TweeAttributedTextField) {
        _ = validate()
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func validate() -> Bool {
        var success = true
        let email = emailTextfield.text ?? ""
        if email.isEmpty {
            emailTextfield.showInfo("Email không được để trống")
            success = false
        } else if !email.isValidEmail {
            emailTextfield.showInfo("Email không đúng định dạng")
            success = false
        } else {
            emailTextfield.hideInfo()
        }
        let password = passwordTextfield.text ?? ""
        if password.isEmpty {
            passwordTextfield.showInfo("Mật khẩu không được để trống")
            success = false
        } else {
            passwordTextfield.hideInfo()
        }
        return success
    }
}
