//
//  EnterOTPVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import SVPinView

class EnterOTPVC: BaseViewController {
    
    @IBOutlet weak var sendOTPButton: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var sendOTPLabel: UILabel!
    var model: PasswordModel
    var timeDown: Int = 30
    var timer = Timer()
    
    init(model: PasswordModel) {
        self.model = model
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
        model.otp = pin
        let vc = SetPasswordVC(model: model)
        navigationController?.pushViewController(vc)
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
        showLoading()
        AuthenWorker.forgotPassword(email: model.email) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
        }
    }
}
