//
//  TabbarVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SideMenuSwift
import ESTabBarController_swift

class TabbarVC: BaseTabbarController {
    
    var mainButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configMainTabbarItem()
    }
    
    func configView() {
        let protectVC = ProtectVC()
        protectVC.title = "Bảo vệ"
        let protectNav = BaseNavigationController(rootViewController: protectVC)
        protectVC.tabBarItem = UITabBarItem(title: "Bảo vệ", image: UIImage(named: "protect_tabbar"), selectedImage: UIImage(named: "protect_tabbar"))
        
        let workspace = WorkspaceVC()
        workspace.title = "Workspace"
        let workspaceNav = BaseNavigationController(rootViewController: workspace)
        workspaceNav.tabBarItem = UITabBarItem(title: "Workspace", image: UIImage(named: "group_tabbar"), selectedImage: UIImage(named: "group_tabbar"))

        let homeVC = HomeVC()
        homeVC.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: nil, image: UIImage(named: "ic_scan_select"), selectedImage: UIImage(named: "ic_scan_select"))
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        
        let notiVC = NotificationVC()
        notiVC.title = "Thông báo"
        let notiNav = BaseNavigationController(rootViewController: notiVC)
        notiNav.tabBarItem = UITabBarItem(title: "Thông báo", image: UIImage(named: "notification_tabbar"), selectedImage: UIImage(named: "notification_tabbar"))
        
        let profileVC = ProfileVC()
        profileVC.title = "Tài khoản"
        let profileNav = BaseNavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Tài khoản", image: UIImage(named: "profile_tabbar"), selectedImage: UIImage(named: "profile_tabbar"))
    
        self.viewControllers = [protectNav, workspaceNav, homeNav, notiNav, profileNav]
        selectedIndex = 2
        tabBar.tintColor = UIColor.black
    }
    
    func configMainTabbarItem() {
        mainButton.setImage(UIImage(named: "ic_scan"), for: .normal)
        mainButton.setImage(UIImage(named: "ic_scan"), for: .highlighted)
        mainButton.addTarget(self, action: #selector(onClickMain), for: .touchUpInside)
        mainButton.cornerRadius = 12
        mainButton.sizeToFit()
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(mainButton)
        mainButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        tabBar.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        mainButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 3).isActive = true
        updateStateMainButton(selected: true)
    }
    
    @objc func onClickMain() {
        if selectedIndex != 2 {
            selectedIndex = 2
            updateStateMainButton(selected: true)
        }
    }
    
    func updateStateMainButton(selected: Bool) {
        if selected {
            mainButton.backgroundColor = UIColor.mainColorOrange()
        } else {
            mainButton.backgroundColor = UIColor(hexString: "061448")
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item is ESTabBarItem {
            updateStateMainButton(selected: true)
        } else {
            updateStateMainButton(selected: false)
        }
        super.tabBar(tabBar, didSelect: item)
    }
}
