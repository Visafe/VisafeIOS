//
//  LoginVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import TweeTextField
import SwifterSwift
import SwiftMessages

class LoginVC: BaseViewController {

    @IBOutlet weak var usernameTextfield: TweeAttributedTextField!
    @IBOutlet weak var passwordTextfield: TweeAttributedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            loginParam.username = usernameTextfield.text
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
            usernameTextfield.showInfo("Tên đăng nhập không được để trống")
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            usernameTextfield.showInfo("Tên đăng nhập không đúng định dạng")
        } else {
            usernameTextfield.hideInfo()
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
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func endEditing(_ sender: TweeAttributedTextField) {
        
    }
}
