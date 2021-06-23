//
//  AppDelegate.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 22/06/2021.
//

import UIKit
import SideMenuSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        setRootVCToTabVC()
        configView()
        configureSideMenu()
        return true
    }
    
    func configView() {
        UITabBar.appearance().backgroundColor = UIColor.black
        UIBarButtonItem.appearance().tintColor = UIColor.black
    }
    
    func setRootVCToTabVC() {
        let vc = TabbarVC()
        self.window?.rootViewController = vc
    }
    
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = kScreenWidth - 100
        SideMenuController.preferences.basic.defaultCacheKey = "0"
    }
}

