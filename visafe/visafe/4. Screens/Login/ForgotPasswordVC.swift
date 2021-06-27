//
//  ForgotPasswordVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import TweeTextField

class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var emailTextfield: TweeAttributedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItem()
    }

    func configNavigationItem() {
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendRequestAction(_ sender: Any) {
        if validate() {
            let email = emailTextfield.text
            showLoading()
            AuthenWorker.forgotPassword(email: email) { [weak self] (result, error) in
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
        model.email = emailTextfield.text
        let vc = EnterOTPVC(model: model)
        navigationController?.pushViewController(vc)
    }
    
    func validate() -> Bool {
        let email = emailTextfield.text ?? ""
        if email.isEmpty {
            emailTextfield.showInfo("Email không được để trống")
            return false
        } else if !email.isValidEmail {
            emailTextfield.showInfo("Email không đúng định dạng")
            return false
        }
        return true
    }
}
