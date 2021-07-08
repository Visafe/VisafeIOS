//
//  TabbarVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SideMenuSwift

class TabbarVC: BaseTabbarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        let protectVC = ProtectVC()
        protectVC.title = "Bảo vệ"
        let protectNav = BaseNavigationController(rootViewController: protectVC)
        
        let groupVC = GroupVC()
        groupVC.title = "Nhóm"
        let groupNav = BaseNavigationController(rootViewController: groupVC)
        
        let notiVC = NotificationVC()
        notiVC.title = "Thông báo"
        let notiNav = BaseNavigationController(rootViewController: notiVC)
        
        let profileVC = ProfileVC()
        profileVC.title = "Tài khoản"
        let profileNav = BaseNavigationController(rootViewController: profileVC)
    
        self.viewControllers = [protectNav, groupNav, notiNav, profileNav]
        let adminItem = self.tabBar.items![0]
        adminItem.image = UIImage(named: "protect_tabbar")
        
        let homeItem = self.tabBar.items![1]
        homeItem.image = UIImage(named: "group_tabbar")
        
        let settingItem = self.tabBar.items![2]
        settingItem.image = UIImage(named: "notification_tabbar")
        
        let profileItem = self.tabBar.items![3]
        profileItem.image = UIImage(named: "profile_tabbar")
        
        selectedIndex = 1
        tabBar.tintColor = UIColor.black
    }
}
