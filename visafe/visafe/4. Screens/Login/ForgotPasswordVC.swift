//
//  ForgotPasswordVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit

class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var usernameTextfield: BaseTextField!
    @IBOutlet weak var usernameInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendRequestAction(_ sender: Any) {
        if validate() {
            let username = usernameTextfield.text ?? "0"
            var name = ""
            if username.isValidEmail {
                name = username
            } else {
                name = "84" + username.dropFirst()
            }
            showLoading()
            AuthenWorker.forgotPassword(username: name) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(result: result, error: error)
            }
        }
    }
    
    func handleResponse(result: ForgotPasswordResult?, error: Error?) {
        if result != nil && error == nil {
            showEnterPasscode()
        } else if let res = result {
            showError(title: "Gửi email không thành công", content: res.status_code?.getDescription())
        }
    }
    
    func showEnterPasscode() {
        let model = PasswordModel()
        let username = usernameTextfield.text ?? "0"
        if username.isValidEmail {
            model.email = username
        } else {
            model.phone_number = "84" + username.dropFirst()
        }
        let vc = EnterOTPVC(model: model,type: .forgotpassword)
        navigationController?.pushViewController(vc)
    }
    
    func validate() -> Bool {
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
        return success
    }
}

extension ForgotPasswordVC: UITextFieldDelegate {
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
