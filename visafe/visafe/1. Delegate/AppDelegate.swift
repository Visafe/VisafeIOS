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
        GIDSignIn.sharedInstance().clientID = "364533202921-h0510keg49fuo2okdgopo48mato4905d.apps.googleusercontent.com"
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (GIDSignIn.sharedInstance().handle(url)) {
            return true
        }
        else if (ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )) {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        postSendToken(token: fcmToken)
    }
    
    func postSendToken(token: String?) {
        // regiser token
        // https://app.visafe.vn/api/v1/device/register
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
//        completionHandler([.list, .banner, .badge])
    }
}
