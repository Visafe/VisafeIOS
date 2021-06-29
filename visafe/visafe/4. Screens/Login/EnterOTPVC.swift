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
    
    @IBOutlet weak var sendOTPButton: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var sendOTPLabel: UILabel!
    var model: PasswordModel
    var timeDown: Int = 30
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
        
        pinView.style = .underline
        pinView.font = UIFont.systemFont(ofSize: 30)
        pinView.keyboardType = .numberPad
        sendOTPLabel.text = "Gửi lại OTP sau \(timeDown)s"
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        
        // start the timer
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func didFinishEnteringPin(pin:String) {
        if type == .activeAccount {
            showLoading()
            model.otp = pin
            AuthenWorker.activeAccount(param: model) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(result: result)
            }
        } else {
            model.otp = pin
            let vc = SetPasswordVC(model: model)
            navigationController?.pushViewController(vc)
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
            CacheManager.shared.setCurrentWorkspace(value: list?.first)
            AppDelegate.appDelegate()?.setRootVCToTabVC()
        }
    }
    
    @objc func timerAction() {
        if timeDown > 1 {
            timeDown -= 1
            sendOTPLabel.text = "Gửi lại OTP sau \(timeDown)s"
            sendOTPLabel.isHidden = false
            sendOTPButton.isUserInteractionEnabled = false
        } else {
            timer.invalidate()
            sendOTPLabel.isHidden = true
            sendOTPButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func reSendOTPAction(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        let username = model.email ?? model.phone_number ?? ""
        AuthenWorker.forgotPassword(username: username) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
        }
    }
}
