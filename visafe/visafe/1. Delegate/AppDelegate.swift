//
//  AppDelegate.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 22/06/2021.
//

import UIKit
import SideMenuSwift
import GoogleSignIn
import FacebookLogin
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        configRootVC()
        configView()
        configureSideMenu()
        googleAuthen()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
    }
    
    func googleAuthen() {
        GIDSignIn.sharedInstance().clientID = "364533202921-h0510keg49fuo2okdgopo48mato4905d.apps.googleusercontent.com"
    }
    
    func configView() {
        UITabBar.appearance().tintColor = UIColor.mainColorOrange()
        UIBarButtonItem.appearance().tintColor = UIColor.black
    }
    
    func configRootVC() {
//        let vc = GroupDetailVC(group: GroupModel())
//        let nav = BaseNavigationController(rootViewController: vc)
//        setRootViewController(vc)
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
    
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = kScreenWidth - 60
        SideMenuController.preferences.basic.defaultCacheKey = "0"
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

