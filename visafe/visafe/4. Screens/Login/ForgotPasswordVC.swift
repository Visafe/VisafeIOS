//
//  ForgotPasswordVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import TweeTextField

class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var bottomButtonContraint: NSLayoutConstraint!
    @IBOutlet weak var usernameTextfield: TweeAttributedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItem()
        configObserve()
    }

    func configNavigationItem() {
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func configObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func onClickLeftButton() {
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
            AuthenWorker.forgotPassword(username: name) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(result: result, error: error)
            }
        }
    }
    
    func handleResponse(result: ForgotPasswordResult?, error: Error?) {
        if result == nil && error == nil {
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
            usernameTextfield.showInfo("Tên đăng nhập không được để trống")
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            usernameTextfield.showInfo("Tên đăng nhập không đúng định dạng")
        } else {
            usernameTextfield.hideInfo()
        }
        return success
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
