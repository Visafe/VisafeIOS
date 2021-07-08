//
//  LoginVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import SwifterSwift
import SwiftMessages

class LoginVC: BaseViewController {

    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var usernameInfoLabel: UILabel!
    @IBOutlet weak var usernameTextfield: BaseTextField!
    @IBOutlet weak var passwordTextfield: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        
        usernameTextfield.setState(type: .normal)
        passwordTextfield.setState(type: .normal)
    }
    
    @IBAction func regiterAction(_ sender: Any) {
        let vc = RegisterVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if validate() {
            showLoading()
            let loginParam = LoginParam()
            let username = usernameTextfield.text ?? "0"
            if username.isValidEmail {
                loginParam.username = username
            } else {
                loginParam.username = "84" + username.dropFirst()
            }
            loginParam.password = passwordTextfield.text
            AuthenWorker.login(param: loginParam) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleLogin(result: result, error: error)
            }
        }
    }
    
    func handleLogin(result: LoginResult?, error: Error?) {
        if let res = result, res.token != nil {
            CacheManager.shared.setLoginResult(value: res)
            getProfile()
        } else {
            let type = LoginStatusEnum.error
            showError(title: "Đăng nhập không thành công", content: type.getDescription())
        }
    }
    
    
    
    func getWorkspaces() {
        WorkspaceWorker.getList { [weak self] (list, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            CacheManager.shared.setIsLogined(value: true)
            CacheManager.shared.setWorkspacesResult(value: list)
            CacheManager.shared.setCurrentWorkspace(value: list?.first)
            AppDelegate.appDelegate()?.setRootVCToTabVC()
        }
    }
    
    func getProfile() {
        showLoading()
        AuthenWorker.profile { [weak self] (user, error) in
            guard let weakSelf = self else { return }
            CacheManager.shared.setCurrentUser(value: user)
            weakSelf.getWorkspaces()
        }
    }
    
    func validate() -> Bool {
        var success = true
        let username = usernameTextfield.text ?? ""
        if username.isEmpty {
            success = false
            usernameInfoLabel.text = "Tên đăng nhập không được để trống"
            usernameTextfield.setState(type: .error)
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            usernameInfoLabel.text = "Tên đăng nhập không đúng định dạng"
            usernameTextfield.setState(type: .error)
        } else {
            usernameInfoLabel.text = nil
            usernameTextfield.setState(type: .normal)
        }
        let password = passwordTextfield.text ?? ""
        if password.isEmpty {
            passwordInfoLabel.text = "Mật khẩu không được để trống"
            passwordTextfield.setState(type: .error)
            success = false
        } else {
            passwordInfoLabel.text = nil
            passwordTextfield.setState(type: .normal)
        }
        return success
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func edittingBegin(_ sender: UITextField) {
    }
}

extension LoginVC: UITextFieldDelegate {
    
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
