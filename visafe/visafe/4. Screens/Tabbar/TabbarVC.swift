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
    let protectVC = ProtectVC()
    let workspace = WorkspaceVC()
    let homeVC = HomeVC()
    let notiVC = NotificationVC()
    let profileVC = ProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configMainTabbarItem()
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeTabNoti), name: NSNotification.Name(rawValue: "kSelectTabNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateNotiCount), name: NSNotification.Name(rawValue: "kUpNotificaionCount"), object: nil)
        
    }
    
    func configView() {
        
        protectVC.title = "Bảo vệ"
        let tab1 = UITabBarItem(title: "Bảo vệ", image: UIImage(named: "protect_tabbar"), selectedImage: UIImage(named: "protect_tabbar"))
        tab1.tag = 1
        protectVC.tabBarItem = tab1
        let protectNav = BaseNavigationController(rootViewController: protectVC)
        
        
        workspace.title = "Workspace"
        let tab2 = UITabBarItem(title: "Workspace", image: UIImage(named: "group_tabbar"), selectedImage: UIImage(named: "group_tabbar"))
        tab2.tag = 2
        workspace.tabBarItem = tab2
        let workspaceNav = BaseNavigationController(rootViewController: workspace)
        
       
        let tab3 = ESTabBarItem.init(ExampleBouncesContentView(), title: nil, image: UIImage(named: "ic_scan_select"), selectedImage: UIImage(named: "ic_scan_select"))
        tab3.tag = 3
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = tab3
        
        notiVC.title = "Thông báo"
        let tab4 = UITabBarItem(title: "Thông báo", image: UIImage(named: "notification_tabbar"), selectedImage: UIImage(named: "notification_tabbar"))
        tab4.tag = 4
        notiVC.tabBarItem = tab4
        let notiNav = BaseNavigationController(rootViewController: notiVC)
        
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
    
    @objc func onChangeTabNoti() {
        selectedIndex = 3
    }
    
    @objc func onUpdateNotiCount() {
        let count = CacheManager.shared.upNotificationCount()
        if count > 0 {
            tabBar.items![3].badgeValue = "\(count)"
        } else {
            tabBar.items![3].badgeValue = nil
        }
    }
    
    func updateStateMainButton(selected: Bool) {
        if selected {
            mainButton.backgroundColor = UIColor.mainColorOrange()
            tabBar.backgroundColor = UIColor(hexString: "0B1A48")
            tabBar.barTintColor = UIColor(hexString: "0B1A48")
            tabBar.isTranslucent = false
        } else {
            mainButton.backgroundColor = UIColor(hexString: "061448")
            tabBar.backgroundColor = UIColor(hexString: "F7F7F7")
            tabBar.isTranslucent = false
            tabBar.barTintColor = UIColor(hexString: "F7F7F7")
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let isLogin = CacheManager.shared.getIsLogined()
        if !isLogin && ([4].contains(item.tag)) {
            showFormLogin(item: item)
        } else {
            super.tabBar(tabBar, didSelect: item)
            if item is ESTabBarItem || [3].contains(item.tag) {
                updateStateMainButton(selected: true)
            } else {
                updateStateMainButton(selected: false)
            }
        }
        if item.tag == 4 {
            item.badgeValue = nil
            CacheManager.shared.resetNotificationCount()
        }
    }
    
    func showFormLogin(item: UITabBarItem) {
        let vc = LoginVC()
        vc.onSuccess = {
            self.notiVC.refreshData()
            self.tabBar(self.tabBar, didSelect: item)
        }
        present(vc, animated: true)
    }
}
