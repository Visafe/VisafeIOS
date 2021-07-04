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
        let adminVC = AdministrationVC()
        adminVC.title = "Quản trị"
        let adminNav = BaseNavigationController(rootViewController: adminVC)
        let leftMenu = LeftMenuVC()
        leftMenu.selectedWorkspace = { workspace in
            adminVC.onChangeWorkspace(workspace: workspace)
        }
        let sideMenuVC = SideMenuController(contentViewController: adminNav, menuViewController: leftMenu)
        sideMenuVC.title = "Quản trị"
        
        let homeVC = HomeVC()
        homeVC.title = "Bảo vệ"
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        
        let settingVC = SettingVC()
        settingVC.title = "Cài đặt"
        let settingNav = BaseNavigationController(rootViewController: settingVC)
    
        
        
        self.viewControllers = [sideMenuVC, homeNav, settingNav]
        let adminItem = self.tabBar.items![0]
        adminItem.image = UIImage(named: "tabbar_admin")
        adminItem.selectedImage = UIImage(named: "tabbar_admin_select")
        
        let homeItem = self.tabBar.items![1]
        homeItem.image = UIImage(named: "tabbar_home")
        homeItem.selectedImage = UIImage(named: "tabbar_home")
        
        let settingItem = self.tabBar.items![2]
        settingItem.image = UIImage(named: "tabbar_setting")
        settingItem.selectedImage = UIImage(named: "tabbar_setting_select")
        
        selectedIndex = 0
        tabBar.tintColor = UIColor.black
    }
}
