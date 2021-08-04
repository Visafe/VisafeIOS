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
        genDeviceId()
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
    
    func configView() {
        let protectVC = ProtectVC()
        protectVC.title = "Bảo vệ"
        let tab1 = UITabBarItem(title: "Bảo vệ", image: UIImage(named: "protect_tabbar"), selectedImage: UIImage(named: "protect_tabbar"))
        tab1.tag = 1
        protectVC.tabBarItem = tab1
        let protectNav = BaseNavigationController(rootViewController: protectVC)
        
        let workspace = WorkspaceVC()
        workspace.title = "Workspace"
        let tab2 = UITabBarItem(title: "Workspace", image: UIImage(named: "group_tabbar"), selectedImage: UIImage(named: "group_tabbar"))
        tab2.tag = 2
        workspace.tabBarItem = tab2
        let workspaceNav = BaseNavigationController(rootViewController: workspace)
        
        let homeVC = HomeVC()
        homeVC.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: nil, image: UIImage(named: "ic_scan_select"), selectedImage: UIImage(named: "ic_scan_select"))
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        
        let notiVC = NotificationVC()
        notiVC.title = "Thông báo"
        let tab4 = UITabBarItem(title: "Thông báo", image: UIImage(named: "notification_tabbar"), selectedImage: UIImage(named: "notification_tabbar"))
        tab4.tag = 4
        notiVC.tabBarItem = tab4
        let notiNav = BaseNavigationController(rootViewController: notiVC)
        
        let profileVC = ProfileVC()
        profileVC.title = "Tài khoản"
        let tab5 = UITabBarItem(title: "Tài khoản", image: UIImage(named: "profile_tabbar"), selectedImage: UIImage(named: "profile_tabbar"))
        tab5.tag = 5
        profileVC.tabBarItem = tab5
        let profileNav = BaseNavigationController(rootViewController: profileVC)
    
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
        let isLogin = CacheManager.shared.getIsLogined()
        if !isLogin && ([4].contains(item.tag)) {
            showFormLogin()
        } else {
            super.tabBar(tabBar, didSelect: item)
        }
    }
    
    func showFormLogin() {
        let vc = LoginVC()
        present(vc, animated: true)
    }
}
