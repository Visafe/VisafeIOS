//
//  LoginVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/24/21.
//

import UIKit
import SwifterSwift
import SwiftMessages
import GoogleSignIn
import FacebookLogin
import AuthenticationServices

class LoginVC: BaseViewController {
    
    var onSuccess:(() -> Void)?
    
    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var usernameInfoLabel: UILabel!
    @IBOutlet weak var usernameTextfield: BaseTextField!
    @IBOutlet weak var passwordTextfield: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        usernameTextfield.setState(type: .normal)
        passwordTextfield.setState(type: .normal)
    }
    
    @IBAction func regiterAction(_ sender: Any) {
        let vc = RegisterVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if validate() {
            showLoading()
            let loginParam = LoginParam()
            let username = usernameTextfield.text ?? "0"
            if username.isValidEmail { // email
                loginParam.username = username
            } else { // sdt
                if username.starts(with: "84") {
                    loginParam.username = username
                } else {
                    loginParam.username = "84" + username.dropFirst()
                }
            }
            loginParam.password = passwordTextfield.text
            AuthenWorker.login(param: loginParam) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.handleLogin(result: result, error: error)
            }
        }
    }
    
    func handleLogin(result: LoginResult?, error: Error?) {
        if let res = result, res.token != nil {
            CacheManager.shared.setPassword(value: passwordTextfield.text!)
            CacheManager.shared.setLoginResult(value: res)
            getProfile()
        } else {
            hideLoading()
            let type = result?.status_code ?? LoginStatusEnum.error
            if type == .unactiveAccount {
                activationAccount()
            } else {
                showError(title: "Đăng nhập không thành công", content: type.getDescription())
            }
        }
    }
    
    func getWorkspaces() {
        WorkspaceWorker.getList { [weak self] (list, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading {
                CacheManager.shared.setIsLogined(value: true)
                CacheManager.shared.setWorkspacesResult(value: list)
                weakSelf.setCurrentWorkspace(list: list ?? [])
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoginSuccess), object: nil)
                if let success = weakSelf.onSuccess {
                    success()
                    weakSelf.dismiss(animated: true, completion: nil)
                } else {
                    AppDelegate.appDelegate()?.setRootVCToTabVC()
                }
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
        AuthenWorker.profile { [weak self] (user, error, responseCode) in
            guard let weakSelf = self else { return }
            CacheManager.shared.setCurrentUser(value: user)
            weakSelf.getWorkspaces()
        }
    }
    
    func validate() -> Bool {
        var success = true
        let username = usernameTextfield.text ?? ""
        if username.isEmpty {
            success = false
            usernameInfoLabel.text = "Tên đăng nhập không được để trống"
            usernameTextfield.setState(type: .error)
        } else if (!username.isValidEmail && !username.isValidPhone()) {
            success = false
            usernameInfoLabel.text = "Tên đăng nhập không đúng định dạng"
            usernameTextfield.setState(type: .error)
        } else {
            usernameInfoLabel.text = nil
            usernameTextfield.setState(type: .normal)
        }
        let password = passwordTextfield.text ?? ""
        if password.isEmpty {
            passwordInfoLabel.text = "Mật khẩu không được để trống"
            passwordTextfield.setState(type: .error)
            success = false
        } else {
            passwordInfoLabel.text = nil
            passwordTextfield.setState(type: .normal)
        }
        return success
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = ForgotPasswordVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
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
    
    @IBAction func edittingBegin(_ sender: UITextField) {
        
    }
    
    func loginFacebook(token: String?) {
        showLoading()
        AuthenWorker.loginFacebook(token: token) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
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
    
    func activationAccount() {
        let model = PasswordModel()
        let username = usernameTextfield.text ?? "0"
        if username.isValidEmail {
            model.email = username
        } else {
            model.phone_number = "84" + username.dropFirst()
        }
        model.password = passwordTextfield.text
        let vc = EnterOTPVC(model: model, type: .activeAccount)
        sendOTP(model: model)
        present(vc, animated: true)
    }
    
    func sendOTP(model: PasswordModel) {
        let username = model.email ?? model.phone_number ?? ""
        AuthenWorker.forgotPassword(username: username) { (result, error, responseCode) in
        }
    }
}

extension LoginVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let token = user?.authentication.idToken {
            showLoading()
            AuthenWorker.loginGoogle(token: token) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.handleLogin(result: result, error: error)
            }
        }
    }
}

extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
            weakSelf.handleLogin(result: result, error: error)
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return AppDelegate.appDelegate()?.window ?? self.view.window!
    }
}


extension LoginVC: UITextFieldDelegate {
    
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
        if textField == usernameTextfield {
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            loginAction(textField)
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
