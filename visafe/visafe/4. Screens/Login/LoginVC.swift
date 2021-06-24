//
//  LoginVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import CocoaTextField
import SwifterSwift

class LoginVC: BaseViewController {

    @IBOutlet weak var emailTextfield: CocoaTextField!
    @IBOutlet weak var passwordTextfield: CocoaTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInputView()
    }
    
    func configInputView() {
        emailTextfield.placeholder = "Email"
        emailTextfield.font = UIFont.systemFont(ofSize: 17)
        emailTextfield.inactiveHintColor = UIColor.lightGray
        emailTextfield.activeHintColor = UIColor.mainColorOrange()
        emailTextfield.focusedBackgroundColor = UIColor.white
        emailTextfield.defaultBackgroundColor = UIColor.white
        emailTextfield.borderColor = UIColor.white
        emailTextfield.errorColor = UIColor.red
        
        passwordTextfield.placeholder = "Mật khẩu"
        passwordTextfield.font = UIFont.systemFont(ofSize: 17)
        passwordTextfield.inactiveHintColor = UIColor.lightGray
        passwordTextfield.activeHintColor = UIColor.mainColorOrange()
        passwordTextfield.focusedBackgroundColor = UIColor.white
        passwordTextfield.defaultBackgroundColor = UIColor.white
        passwordTextfield.borderColor = UIColor.white
        passwordTextfield.errorColor = UIColor.red
    }
    
    @IBAction func regiterAction(_ sender: Any) {
        let registerVC = RegisterVC()
        present(registerVC, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
    }
}
