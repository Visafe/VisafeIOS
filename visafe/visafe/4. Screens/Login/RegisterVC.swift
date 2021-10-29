//
//  RegisterVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import SwiftMessages
import GoogleSignIn
import FacebookLogin
import AuthenticationServices

class RegisterVC: BaseViewController {

    @IBOutlet weak var fullNameTextfield: BaseTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fullnameInfoLabel: UILabel!
    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var usernameInfoLabel: UILabel!
    @IBOutlet weak var usernameTextfield: BaseTextField!
    @IBOutlet weak var passwordTextfield: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        let mutableAttributedString = NSMutableAttributedString.init(string: "Khi nhấn Đăng ký, bạn đã đồng ý với ")
        let attribute1 = NSAttributedString(string: "Điều khoản & Chính sách", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "15A1FA")!])
        let attribute2 = NSAttributedString(string: " dành cho khách hàng của")
        let attribute3 = NSAttributedString(string: " Visafe", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        mutableAttributedString.append(attribute1)
        mutableAttributedString.append(attribute2)
        mutableAttributedString.append(attribute3)
        descriptionLabel.attributedText = mutableAttributedString
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if validateInfo() {
            register()
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let fullname = fullNameTextfield.text ?? ""
        if fullname.isEmpty {
            success = false
            fullnameInfoLabel.text = "Tên người dùng không được để trống"
        } else if fullname.length > 50 {
            success = false
            fullnameInfoLabel.text = "Tên người dùng không được lớn hơn 50 ký tự"
        }  else {
            fullnameInfoLabel.text = nil
        }
        let username = usernameTextfield.text ?? ""
        if username.isEmpty {
            success = false
            usernameInfoLabel.text = "Số điện thoại/email không được để trống"
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            usernameInfoLabel.text = "Số điện thoại/email không đúng định dạng"
        } else {
            usernameInfoLabel.text = nil
        }
        let password = passwordTextfield.text ?? ""
        if password.isEmpty {
            success = false
            passwordInfoLabel.text = "Mật khẩu không được để trống"
        } else {
            passwordInfoLabel.text = nil
        }
        return success
    }
    
    func register() {
        let param = RegisterParam()
        let username = usernameTextfield.text ?? "0"
        if username.isValidEmail {
            param.email = username
        } else {
            param.phone_number = "84" + username.dropFirst()
        }
        param.full_name = fullNameTextfield.text
        param.password = passwordTextfield.text
        param.repeat_password = passwordTextfield.text
        showLoading()
        AuthenWorker.register(param: param) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.handleRegisterResult(result: result, error: error)
        }
    }
    
    func handleRegisterResult(result: ResgisterResult?, error: Error?) {
        if result?.status_code == .successWithEmail || result?.status_code == .successWithPhone {
            let model = PasswordModel()
            let username = usernameTextfield.text ?? "0"
            if username.isValidEmail {
                model.email = username
            } else {
                model.phone_number = "84" + username.dropFirst()
            }
            model.password = passwordTextfield.text
            let vc = EnterOTPVC(model: model, type: .activeAccount)
            navigationController?.pushViewController(vc)
        } else {
            let errorCode = result?.status_code ?? .error
            showError(title: "Đăng ký không thành công", content: errorCode.getDescription())
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func googleAuthen(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookAuthen(_ sender: UIButton) {
        let manager = LoginManager()
        manager.logIn(permissions: [], from: self) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            if let token = result?.token?.tokenString {
                weakSelf.loginFacebook(token: token)
            }
        }
    }
    
    @IBAction func appleAuthen(_ sender: UIButton) {
        loginApple()
    }
    
    
    func loginFacebook(token: String?) {
        showLoading()
        AuthenWorker.loginFacebook(token: token) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.handleLogin(result: result, error: error)
        }
    }
    
    func loginApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func handleLogin(result: LoginResult?, error: Error?) {
        if let res = result, res.token != nil {
            CacheManager.shared.setLoginResult(value: res)
            getProfile()
        } else {
            let type = LoginStatusEnum.error
            showError(title: "Đăng nhập không thành công", content: type.getDescription())
        }
    }
    
    func getWorkspaces() {
        WorkspaceWorker.getList { [weak self] (list, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading {
                CacheManager.shared.setIsLogined(value: true)
                CacheManager.shared.setWorkspacesResult(value: list)
                weakSelf.setCurrentWorkspace(list: list ?? [])
                AppDelegate.appDelegate()?.setRootVCToTabVC()
            }
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
    
    func getProfile() {
        showLoading()
        AuthenWorker.profile { [weak self] (user, error, responseCode) in
            guard let weakSelf = self else { return }
            CacheManager.shared.setCurrentUser(value: user)
            weakSelf.getWorkspaces()
        }
    }
}

extension RegisterVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let token = user?.authentication.idToken {
            showLoading()
            AuthenWorker.loginGoogle(token: token) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleLogin(result: result, error: error)
            }
        }
    }
}

extension RegisterVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let identityToken = appleIDCredential.identityToken {
            let token_string =  String(decoding: identityToken, as: UTF8.self)
            loginApple(token: token_string)
        }
    }
    
    func loginApple(token: String?) {
        showLoading()
        AuthenWorker.loginApple(token: token) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.handleLogin(result: result, error: error)
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return AppDelegate.appDelegate()?.window ?? self.view.window!
    }
}

extension RegisterVC: UITextFieldDelegate {
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextfield {
            usernameTextfield.becomeFirstResponder()
        } else if textField == usernameTextfield {
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            if validateInfo() {
                register()
                return true
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
