//
//  EnterPinVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit
import SVPinView

class EnterPinVC: BaseViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var heightButtonDelete: NSLayoutConstraint!
    
    var onUpdate:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinView.style = .underline
        pinView.font = UIFont.systemFont(ofSize: 24)
        pinView.keyboardType = .numberPad
        pinView.shouldSecureText = true
        pinView.secureTextDelay = 0
        pinView.didChangeCallback = didChangeEnteringPin(pin:)
        didChangeEnteringPin(pin: "")
        if CacheManager.shared.getPin() != nil {
            title = "Cập nhật mã bảo vệ"
            heightButtonDelete.constant = 44
            deleteButton.isHidden = false
        } else {
            title = "Tạo mã bảo vệ"
            heightButtonDelete.constant = 0
            deleteButton.isHidden = true
        }
        pinView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let pin = CacheManager.shared.getPin() {
            pinView.pastePin(pin: pin)
            didChangeEnteringPin(pin: pinView.getPin())
        }
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
    
    @IBAction func deleteAction(_ sender: UIButton) {
        pinView.clearPin()
        CacheManager.shared.setPin(value: nil)
        onUpdate?()
        didChangeEnteringPin(pin: pinView.getPin())
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        CacheManager.shared.setPin(value: pinView.getPin())
        onUpdate?()
        navigationController?.popViewController()
    }
}
