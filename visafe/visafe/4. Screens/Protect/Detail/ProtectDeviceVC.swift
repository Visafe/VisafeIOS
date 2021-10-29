//
//  ProtectDeviceVC.swift
//  visafe
//
//  Created by QuocNV on 8/3/21.
//

import UIKit
import PageMenu
import SystemConfiguration.CaptiveNetwork
import CoreLocation

class ProtectDeviceVC: HeaderedPageMenuScrollWithDoHViewController, CAPSPageMenuDelegate {
    var subPageControllers: [UIViewController] = []
    var header: ProtectHomeHeaderView!
    var group: GroupModel
    var type: ProtectHomeType
    var statistic: StatisticModel
    var listBlockVC: ProtectDetailListBlockVC!
    var pageMenu: CAPSPageMenu!
    var isSet = false

    var onUpdateGroup:(() -> Void)?

    init(group: GroupModel,
         statistic: StatisticModel,
         type: ProtectHomeType) {
        self.group = group
        self.type = type
        self.statistic = statistic
        super.init(nibName: ProtectDeviceVC.className, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.headerHeight = 275
        super.viewDidLoad()
        configBarItem()
        configView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProtectDevice),
                                               name: NSNotification.Name(rawValue: updateDnsStatus),
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if !isSet {
            isSet = true
            pageMenu.view.frame = CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height)
            listBlockVC.view.frame = CGRect(x: 0, y: 56, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height - 100)
        }
    }

    func configView() {
        header = ProtectHomeHeaderView.loadFromNib()
        header.bindingData(type: type)

        let isOn = type == .device ? DoHNative.shared.isEnabled: CacheManager.shared.getProtectWifiStatus()
        header.updateState(isOn: isOn)

        header.switchValueChange = { [weak self] isOn in
            guard let self = self else { return }
            if self.type == .wifi {
                CacheManager.shared.setProtectWifiStatus(value: isOn)
                self.listBlockVC.setProtect(isOn)
            } else if self.type == .device {
                self.onOffDoH()
            }
        }

        // 1) Set the header
        self.headerView = header

        // 2) Set the subpages
        listBlockVC = ProtectDetailListBlockVC(group: group,
                                               statistic: statistic,
                                               type: type)
        listBlockVC.title = type.getTitleContentView()
        listBlockVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        listBlockVC.view.backgroundColor = .white
        addChild(listBlockVC)
        subPageControllers.append(listBlockVC)
        listBlockVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        listBlockVC.setProtect(isOn)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemWidth(kScreenWidth),
            .viewBackgroundColor(.white),
            .menuItemFont(UIFont.systemFont(ofSize: 16, weight: .semibold)),
            .menuHeight(56),
            .selectedMenuItemLabelColor(.black),
            .unselectedMenuItemLabelColor(UIColor(hexString: "222222")!),
            .menuMargin(0),
            .centerMenuItems(false),
            .scrollMenuBackgroundColor(.white)
        ]
        pageMenu = CAPSPageMenu(viewControllers: subPageControllers, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height), pageMenuOptions: parameters)
        self.addPageMenu(menu: pageMenu)
        self.pageMenuController!.delegate = self

        self.navBarColor = UIColor.white
        self.headerBackgroundColor = UIColor.white
        self.navBarItemsColor = UIColor.black
        self.navBarTransparancy = 1.0
    }

    func configBarItem() {
        title = type.getTitle()
        navigationController?.title = type.getTitle()
    }

    //MARK: DoH
    override func showAnimationConnectLoading() {
        showLoading()
    }

    override func hideAnimationLoading() {
        hideLoading()
        listBlockVC.setProtect(DoHNative.shared.isEnabled)
        header.updateState(isOn: DoHNative.shared.isEnabled)
    }

    @objc private func updateProtectDevice() {
        listBlockVC.setProtect(DoHNative.shared.isEnabled)
        header.updateState(isOn: DoHNative.shared.isEnabled)
    }
}
