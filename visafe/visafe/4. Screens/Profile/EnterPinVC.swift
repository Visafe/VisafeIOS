//
//  EnterPinVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
//import SVPinView
import IQKeyboardManagerSwift

class EnterPinVC: BaseViewController {
    enum PinScreenType {
        case create
        case change
        case confirm
        case confirmToOffDoH
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var heightButtonDelete: NSLayoutConstraint!
    
    var onUpdate:(() -> Void)?
    var confirmPin:((Bool) -> Void)?

    var confirmPass: String?
    var screenType: PinScreenType = CacheManager.shared.getPin() != nil ? .change: .create
    var enableButton = true {
        didSet {
            if oldValue != enableButton {
                continueButton.backgroundColor = enableButton ? UIColor.mainColorOrange(): UIColor(hexString: "F8F8F8")
                continueButton.setTitleColor(enableButton ? UIColor.white: UIColor(hexString: "111111"),
                                             for: .normal)
                continueButton.isUserInteractionEnabled = enableButton
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pinView.style = .underline
        pinView.font = UIFont.systemFont(ofSize: 24)
        pinView.keyboardType = .numberPad
        pinView.shouldSecureText = true
        pinView.secureTextDelay = 0
        pinView.didChangeCallback = didChangeEnteringPin(pin:)
        pinView.isUserInteractionEnabled = false
        didChangeEnteringPin(pin: "")
        setupUI()

        pinView.becomeFirstResponderAtIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupUI() {
        switch screenType {
        case .change:
            title = "Cập nhật mã bảo vệ"
            heightButtonDelete.constant = 44
            deleteButton.isHidden = false
        case .create:
            title = "Tạo mã bảo vệ"
            heightButtonDelete.constant = 0
            deleteButton.isHidden = true
            titleLabel.text = confirmPass == nil ? "Tạo mã bảo vệ mới": "Xác nhận mã bảo vệ mới"
        case .confirm:
            title = "Cập nhật mã bảo vệ"
            heightButtonDelete.constant = 0
            deleteButton.isHidden = true
            continueButton.isHidden = true
            titleLabel.text = "Nhập mã bảo vệ hiện tại"
        case .confirmToOffDoH:
            title = "Xác nhận mã bảo vệ"
            heightButtonDelete.constant = 0
            deleteButton.isHidden = true
            continueButton.isHidden = true
            titleLabel.text = "Nhập mã bảo vệ hiện tại"
            let bt = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .plain, target: self, action: #selector(close))
            navigationItem.rightBarButtonItem = bt

        }
    }
    
    func didChangeEnteringPin(pin:String) {
        if pin.count == 6 {
            switch screenType {
            case .confirm:
                guard let currentPin = CacheManager.shared.getPin() else {
                    return
                }
                if pin == currentPin {
                    let vc = EnterPinVC()
                    vc.onUpdate = onUpdate
                    navigationController?.pushViewController(vc)
                } else {
                    showWarning(title: "Thông báo", content: "Sai mã pin")
                }
            case .confirmToOffDoH:
                guard let currentPin = CacheManager.shared.getPin() else {
                    return
                }

                if pin == currentPin {
                    confirmPin?(true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    showWarning(title: "Thông báo", content: "Sai mã pin")
                }
            default:
                if let confirm = confirmPass {
                    enableButton = pin == confirm
                } else {
                    enableButton = true
                }
            }
        } else {
            enableButton = false
        }
    }

    @objc func close() {
        confirmPin?(false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        pinView.refreshView()
        CacheManager.shared.setPin(value: nil)
        onUpdate?()
        didChangeEnteringPin(pin: "")
        backToSetting()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        switch screenType {
        case .create, .change:
            handleContiue()
        case .confirm, .confirmToOffDoH: break
        }
    }

    func handleContiue() {
        if confirmPass == nil {
            let vc = EnterPinVC()
            vc.confirmPass = pinView.getPin()
            vc.onUpdate = onUpdate
            navigationController?.pushViewController(vc)
        } else {
            CacheManager.shared.setPin(value: pinView.getPin())
            onUpdate?()
            backToSetting()
        }
    }

    func backToSetting() {
        guard let vc = self.navigationController?.viewControllers[safe: 1] as? ProfileSettingVC else {
            return
        }
        self.navigationController?.popToViewController(vc, animated: true)
    }
}
