//
//  SetPasswordVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import TweeTextField

class SetPasswordVC: BaseViewController {
    
    @IBOutlet weak var passwordTextfield: TweeAttributedTextField!
    @IBOutlet weak var bottomButtonContraint: NSLayoutConstraint!
    @IBOutlet weak var rePasswordTextfield: TweeAttributedTextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var model: PasswordModel

    override func viewDidLoad() {
        super.viewDidLoad()
        configObserve()
    }
    
    init(model: PasswordModel) {
        self.model = model
        super.init(nibName: SetPasswordVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validateInfo() {
            let param = ResetPassParam()
            param.username = model.email ?? model.phone_number
            param.password = passwordTextfield.text
            param.otp = model.otp
            param.repeat_password = rePasswordTextfield.text
            showLoading()
            AuthenWorker.resetPassword(param: param) { [weak self] (result, error) in
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
    
    func handleResponse(result: ResetPasswordResult?, error: Error?) {
        if result == nil && error != nil {
            authen()
        } else if let res = result {
            showError(title: "Đặt mật khẩu lỗi", content: res.status_code?.getDescription())
        }
    }
    
    func authen() {
        let loginParam = LoginParam()
        loginParam.username = model.email ?? model.phone_number
        loginParam.password = passwordTextfield.text
        AuthenWorker.login(param: loginParam) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.handleLogin(result: result, error: error)
        }
    }

    func handleLogin(result: LoginResult?, error: Error?) {
        if let res = result {
            if res.token != nil { // login thanh cong
                CacheManager.shared.setLoginResult(value: res)
                actionAfterLogin()
            } else {
                let type = res.status_code ?? .error
                showError(title: "Đăng nhập không thành công", content: type.getDescription())
            }
        } else {
            let type = LoginStatusEnum.error
            showError(title: "Đăng nhập không thành công", content: type.getDescription())
        }
    }
    
    func actionAfterLogin() {
        showLoading()
        WorkspaceWorker.getList { [weak self] (list, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            CacheManager.shared.setIsLogined(value: true)
            CacheManager.shared.setWorkspacesResult(value: list)
            CacheManager.shared.setCurrentWorkspace(value: list?.first)
            AppDelegate.appDelegate()?.setRootVCToTabVC()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.bottomButtonContraint.constant =  30
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.bottomButtonContraint.constant = keyboardHeight + 10
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}
