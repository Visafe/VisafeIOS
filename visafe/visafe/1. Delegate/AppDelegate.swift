//
//  AppDelegate.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 22/06/2021.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import FirebaseMessaging
import FBSDKCoreKit
import GoogleSignIn
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        genDeviceId()
        configApplePush(application) // đăng ký nhận push.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        configRootVC()
        configView()
        googleAuthen()
        configKeyboard()
        return true
    }
    
    func configKeyboard() {
        IQKeyboardManager.shared.enable = true
    }
    
    func googleAuthen() {
        FirebaseApp.configure() // gọi hàm để cấu hình 1 app Firebase mặc định
        Messaging.messaging().delegate = self //Nhận các message từ FirebaseMessaging
        //google sign in
        GIDSignIn.sharedInstance().clientID = "364533202921-h0510keg49fuo2okdgopo48mato4905d.apps.googleusercontent.com"
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (GIDSignIn.sharedInstance().handle(url)) {
            return true
        }
        else if (ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )) {
            return true
        } else if url.absoluteString.checkDeeplink() != nil {
            handleUniversallink(code: url.absoluteString)
            return true
        }
        return false
    }
    
    func handleUniversallink(code: String) {
        guard let link = code.checkDeeplink() else { return }
        let param = Common.getDeviceInfo()
        param.updateGroupInfo(link: link)
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Xác nhận tham gia", message: "Bạn có chắc chắn muốn tham gia nhóm <" + (param.groupName ?? "") + "> với tên là:", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Tên thiết bị"
        }
        alertController.textFields![0].text = param.deviceName
        // add the buttons/actions to the view controller
        let saveAction = UIAlertAction(title: "Đồng ý", style: .cancel) { [weak self] alert in
            guard let weakSelf = self else { return }
            let inputName = alertController.textFields![0].text
            param.deviceName = inputName
            weakSelf.addDeviceToGroup(device: param)
        }
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .default, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func addDeviceToGroup(device: AddDeviceToGroupParam) {
        GroupWorker.addDevice(param: device) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            if result?.status_code == .success {
                let alert = UIAlertController(title: "Thông báo", message: "Tham gia nhóm thành công" , preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) { _ in }
                // add an action (button)
                alert.addAction(okAction)
                // show the alert
                weakSelf.window?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                let type = result?.status_code ?? .defaultStatus
                let message_alert = type.getDescription()
                let alert = UIAlertController(title: "Thông báo", message: message_alert , preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style:
                                                UIAlertAction.Style.default) { _ in }
                // add an action (button)
                alert.addAction(okAction)
                // show the alert
                weakSelf.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func postSendToken(token: String?) {
        // regiser token
        DeviceWorker.registerDevice(token: token) { (result, error) in }
    }

    func configApplePush(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func configView() {
        UITabBar.appearance().tintColor = UIColor.mainColorOrange()
        UIBarButtonItem.appearance().tintColor = UIColor.black
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "navi_back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "navi_back")
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    func configRootVC() {
        if CacheManager.shared.getIsShowOnboarding() {
            setRootVCToTabVC()
        } else {
            setRootVCToOnboardingVC()
        }
    }
    
    func setRootVCToTabVC() {
        let vc = TabbarVC()
        setRootViewController(vc)
    }
    
    func setRootVCToOnboardingVC() {
        let vc = OnboardingVC()
        setRootViewController(vc)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            if url.absoluteString.checkDeeplink() != nil {
                handleUniversallink(code: url.absoluteString)
                return true
            }
        }
        return true
    }
    
    func genDeviceId() {
        if !CacheManager.shared.isDeviceIdExist() {
            DeviceWorker.genDeviceId { (result, error) in
                if let deviceId = result?.deviceId {
                    CacheManager.shared.setDeviceId(value: deviceId)
                }
            }
        }
    }
}

extension AppDelegate {
    class func appDelegate() -> AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }

        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func getTopViewController() -> UIViewController? {
        var topViewController = self.window?.rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .badge])
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        postSendToken(token: fcmToken)
    }
}
