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
import ObjectMapper

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        } catch {}
        genDeviceId()
        appInit()
        configApplePush(application) // đăng ký nhận push.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        configRootVC()
        configView()
        googleAuthen()
        configKeyboard()
        handlePush(launchOptions: launchOptions)

        return true
    }
    
    func handlePush(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kSelectTabNoti"), object: nil)
        }
    }

    func appInit() {
        RoutingWorker.getDnsServer { data, _, _ in
            guard let hostname = data?.hostname else {
                CacheManager.shared.setDnsServer(value: dnsServer)
                if #available(iOS 14.0, *) {
                    DoHNative.shared.resetDnsSetting()
                } else {
                    // Fallback on earlier versions
                }
                return
            }
            var dns = hostname
            if dns.last == "/" {
                dns.removeLast()
            }
            if !dns.contains("https://") && !dns.contains("http://") {
                dns = "https://" + dns + "/dns-query/%@"
            }
            CacheManager.shared.setDnsServer(value: dns)
            if #available(iOS 14.0, *) {
                DoHNative.shared.resetDnsSetting()
            } else {
                // Fallback on earlier versions
            }
        }

//        if CacheManager.shared.getDailyReport() == nil {
//            CacheManager.shared.setDailyReport(value: true)
//        }
    }
    
    func configKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
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
        } else if url.absoluteString.contains("firebase.visafe.vn") {
            DynamicLinks.dynamicLinks().handleUniversalLink(url) {[weak self] dynamiclink, error in
                guard let _url = dynamiclink?.url else { return }
                if _url.absoluteString.checkInviteDevicelink() != nil {
                    self?.handleUniversallink(code: _url.absoluteString)
                } else if _url.absoluteString.checkPaymentlink() != nil {
                    self?.handlePaymentLink(code: _url.absoluteString)
                }
            }
            return true
        }

        return false
    }
    
    func handleUniversallink(code: String) {
        guard let link = code.checkInviteDevicelink() else { return }
        let param = Common.getDeviceInfo()
        param.updateGroupInfo(link: link)
        let vc = JoinGroupVC(param: param)
        let nav = BaseNavigationController(rootViewController: vc)
        self.window?.rootViewController?.present(nav, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken

//        Messaging.messaging().subscribe(toTopic: "topicName")

//        Messaging.messaging().unsubscribe(fromTopic: "topicName")
    }
    
    func postSendToken(token: String?) {
        // regiser token
        DeviceWorker.registerDevice(token: token) { (result, error, responseCode) in }
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
            guard let url = userActivity.webpageURL else { return true }
            DynamicLinks.dynamicLinks().handleUniversalLink(url) {[weak self] dynamiclink, error in
                guard let _url = dynamiclink?.url else { return }
                if _url.absoluteString.checkInviteDevicelink() != nil {
                    self?.handleUniversallink(code: _url.absoluteString)
                } else if _url.absoluteString.checkPaymentlink() != nil {
                    self?.handlePaymentLink(code: _url.absoluteString)
                }
            }
        }
        return true
    }

    func genDeviceId() {
        if !CacheManager.shared.isDeviceIdExist() {
            DeviceWorker.genDeviceId { (result, error, responseCode) in
                if let deviceId = result?.deviceId {
                    CacheManager.shared.setDeviceId(value: deviceId)
                }
            }
        }
    }
    
    func handlePaymentLink(code: String) {
        if let url = URL(string: code), let dic = url.queryParameters {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPaymentSuccess), object: nil, userInfo: dic)
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kUpNotificaionCount"), object: nil)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func logout() {
        CacheManager.shared.setIsLogined(value: false)
        CacheManager.shared.removeCurrentUser()
        CacheManager.shared.setCurrentWorkspace(value: nil)
        CacheManager.shared.setPin(value: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoginSuccess), object: nil)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .badge])
        } else {
            
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        CacheManager.shared.setFCMToken(value: fcmToken)
        postSendToken(token: fcmToken)
    }
}
