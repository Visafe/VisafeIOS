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
    @IBOutlet weak var rePasswordTextfield: TweeAttributedTextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var model: PasswordModel

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(model: PasswordModel) {
        self.model = model
        super.init(nibName: SetPasswordVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validateInfo() {
            let param = ResetPassParam()
            param.email = model.email
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
        if result != nil && error != nil {
            authen()
        } else if let res = result {
            showError(title: "Đặt mật khẩu lỗi", content: res.status_code?.getDescription())
        }
    }
    
    func authen() {
        
    }
}
