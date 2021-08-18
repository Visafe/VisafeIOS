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

class ProtectDeviceVC: HeaderedPageMenuScrollViewController, CAPSPageMenuDelegate {
    var subPageControllers: [UIViewController] = []
    var header: ProtectHomeHeaderView!
    var group: GroupModel
    var type: ProtectHomeType
    var statistic: StatisticModel
    var listBlockVC: ProtectDetailListBlockVC!

    var onUpdateGroup:(() -> Void)?

    var locationManager = CLLocationManager()
    var currentNetworkInfos: Array<NetworkInfo>? {
        get {
            return SSID.fetchNetworkInfo()
        }
    }

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

        if type == .wifi {
            if #available(iOS 14.0, *) {
                let status = locationManager.authorizationStatus
                if status == .authorizedWhenInUse {
                    updateWiFi()
                } else {
                    locationManager.delegate = self
                    locationManager.requestWhenInUseAuthorization()
                }
            } else {
                updateWiFi()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func configView() {
        header = ProtectHomeHeaderView.loadFromNib()
        header.bindingData(type: type)

        let isOn = type == .device ? DoHNative.shared.isEnabled: CacheManager.shared.getProtectWifiStatus()
        header.updateState(isOn: isOn)

        header.switchValueChange = { [weak self] isOn in
            guard let self = self else { return }
            self.listBlockVC.setProtect(isOn)
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
        self.addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height), pageMenuOptions: parameters))
        self.pageMenuController!.delegate = self

        self.headerBackgroundColor = UIColor.white
        self.navBarColor = UIColor.black
    }

    func configBarItem() {
        title = type.getTitle()
        navigationController?.title = type.getTitle()
    }
}

extension ProtectDeviceVC: CLLocationManagerDelegate {
    func updateWiFi() {
        header.setContent(currentNetworkInfos?.first?.ssid ?? "")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            updateWiFi()
        }
    }
}

public class SSID {
    class func fetchNetworkInfo() -> [NetworkInfo]? {
        if let interfaces: NSArray = CNCopySupportedInterfaces() {
            var networkInfos = [NetworkInfo]()
            for interface in interfaces {
                let interfaceName = interface as! String
                var networkInfo = NetworkInfo(interface: interfaceName,
                                              success: false,
                                              ssid: nil,
                                              bssid: nil)
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    networkInfo.success = true
                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                }
                networkInfos.append(networkInfo)
            }
            return networkInfos
        }
        return nil
    }
}

struct NetworkInfo {
    var interface: String
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}
