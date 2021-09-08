//
//  EnterOTPVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import SVPinView

public enum EnterOTPEnum: Int {
    case activeAccount = 1
    case forgotpassword = 2
}

class EnterOTPVC: BaseViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var sendOTPButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pinView: SVPinView!
    var model: PasswordModel
    var timeDown: Int = 90
    var timer = Timer()
    var type: EnterOTPEnum
    
    init(model: PasswordModel, type: EnterOTPEnum) {
        self.model = model
        self.type = type
        super.init(nibName: EnterOTPVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.backgroundColor = UIColor(hexString: "F8F8F8")
        continueButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
        continueButton.isUserInteractionEnabled = false
        
        pinView.style = .underline
        pinView.font = UIFont.systemFont(ofSize: 24)
        pinView.keyboardType = .numberPad
        if let phone = model.phone_number, !phone.isEmpty {
            descriptionLabel.text = "Visafe đã gửi mã xác thực OTP đến số điện thoại \(phone)"
        } else if let email = model.email, !email.isEmpty {
            descriptionLabel.text = "Visafe đã gửi mã xác thực OTP đến số email \(email)"
        } else {
            descriptionLabel.text = "Visafe đã gửi mã xác thực OTP đến tài khoản của bạn"
        }
        sendOTPButton.setTitle("Gửi lại OTP (\(timeDown)s)", for: .normal)
        pinView.didChangeCallback = didChangeEnteringPin(pin:)
        
        let mutableAttributedString = NSMutableAttributedString.init(string: "Visafe đã gửi mã xác thực OTP đến tài khoản\n\n")
        let attribute2 = NSAttributedString(string: model.phone_number ?? model.email ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        mutableAttributedString.append(attribute2)
        descriptionLabel.attributedText = mutableAttributedString
        
        // start the timer
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func didChangeEnteringPin(pin:String) {
        if pin.count == 6 {
            continueButton.backgroundColor = UIColor.mainColorOrange()
            continueButton.setTitleColor(UIColor.white, for: .normal)
            continueButton.isUserInteractionEnabled = true
        } else {
            continueButton.backgroundColor = UIColor(hexString: "F8F8F8")
            continueButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
            continueButton.isUserInteractionEnabled = false
        }
    }
    
    func handleResponse(result: ActiveAccountResult?) {
        if result?.status_code == .success {
            // thực hiện login lại
            let loginParam = LoginParam()
            loginParam.username = model.email ?? model.phone_number
            loginParam.password = model.password
            AuthenWorker.login(param: loginParam) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.handleLogin(result: result, error: error)
            }
        } else {
            let type = result?.status_code ?? .inccorectinfo
            showError(title: "Xác thực không thành công", content: type.getDescription())
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
            weakSelf.setCurrentWorkspace(list: list ?? [])
            AppDelegate.appDelegate()?.setRootVCToTabVC()
        }
    }
    
    func setCurrentWorkspace(list: [WorkspaceModel]) {
        if let workspace = list.first(where: { (m) -> Bool in
            return m.id == CacheManager.shared.getCurrentUser()?.defaultWorkspace
        }) {
            CacheManager.shared.setCurrentWorkspace(value: workspace)
        } else {
            CacheManager.shared.setCurrentWorkspace(value: list.first)
        }
    }
    
    @objc func timerAction() {
        if timeDown > 1 {
            timeDown -= 1
            sendOTPButton.setTitle("Gửi lại OTP (\(timeDown)s)", for: .normal)
            sendOTPButton.isUserInteractionEnabled = false
        } else {
            timer.invalidate()
            sendOTPButton.setTitle("Gửi lại OTP", for: .normal)
            sendOTPButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func reSendOTPAction(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        showLoading()
        let username = model.email ?? model.phone_number ?? ""
        AuthenWorker.forgotPassword(username: username) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
        }
    }
    @IBAction func backAction(_ sender: Any) {
        if let _ = navigationController?.popViewController() {
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        if type == .activeAccount {
            showLoading()
            model.otp = pinView.getPin()
            AuthenWorker.activeAccount(param: model) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(result: result)
            }
        } else {
            model.otp = pinView.getPin()
            let vc = SetPasswordVC(model: model)
            navigationController?.pushViewController(vc)
        }
    }
}
