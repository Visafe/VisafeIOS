//
//  HomeVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import NetworkExtension

class HomeVC: BaseViewController {

    enum NativeDnsProviderError: Error {
        case unsupportedDnsProtocol
        case failedToLoadManager
        case unsupportedProtocolsConfiguration
        case invalidUpstreamsNumber
    }

    @IBOutlet weak var homeLoadingImage: UIImageView!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var earthImageView: UIImageView!
    @IBOutlet weak var connectButton: UIButton!

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var desImageView: UIImageView!

    var providerManagerType: NETunnelProviderManager.Type = NETunnelProviderManager.self
    private var vpnInstalledValue: Bool?
    var manager: NETunnelProviderManager!
    var session: NETunnelProviderSession!
    let gradient = CAGradientLayer()
    var isEnabled = false {
        didSet {
            updateUI()
        }
    }

    var isInstalled = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateDNSStatus()
//        initVpn()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDNSStatus), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gradient.frame = view.bounds
        connectionView.layer.cornerRadius = connectionView.bounds.width/2
    }

    @objc func updateDNSStatus() {
        getDnsManagerStatus { (isInstalled, isEnabled) in
            self.isInstalled = isInstalled
            self.isEnabled = isEnabled
        }
    }

    func setupUI() {
        homeLoadingImage.alpha = 0
        connectionView.clipsToBounds = true
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [UIColor.color_0F1733.cgColor, UIColor.color_102366.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }

    func updateUI() {
        firstLabel.text = isEnabled ? "": "Bấm "
        lastLabel.text = isEnabled ? "Đang được bảo vệ": " để bật tính năng bảo vệ"
        desImageView.image = isEnabled ? UIImage(named: "Shield_Done"): UIImage(named: "power")
        earthImageView.image = isEnabled ? UIImage(named: "connection_success"): UIImage(named: "no_connection")
        connectButton.setImage(isEnabled ? UIImage(named: "connect_on"): UIImage(named: "connect_off"), for: .normal)
        homeLoadingImage.image = isEnabled ? UIImage(named: "ic_power_on"): nil
    }
    
    func showAnimationLoading() {
        self.homeLoadingImage.rotate()
        self.homeLoadingImage.image = UIImage(named: "ic_loading_home")
        UIView.animate(withDuration: 0.75) {
            self.homeLoadingImage.alpha = 1
        } completion: { (success) in
        }
    }
    
    func hideAnimationLoading() {
        self.homeLoadingImage.endRotate()
        UIView.animate(withDuration: 0.75) {
            self.homeLoadingImage.alpha = 0
        } completion: { (success) in
        }
    }
    
    func updateStateProtect(isOn: Bool) {
        if isOn {
            
        } else {
            
        }
    }

    @IBAction func connectAction(_ sender: Any) {
        showAnimationLoading()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(handleEnabelSuccess(sender:)), userInfo: nil , repeats:false)
//        if isInstalled {
//            if isEnabled {
//                removeDnsManager {[weak self] (error) in
//                    if let _error = error {
//                        self?.showError(title: "Thông báo", content: _error.localizedDescription)
//                    }
//                }
//            } else {
//                showError(title: "Thông báo", content: "Vui lòng vào Cài đặt -> Cài đặt chung -> VPN -> DNS để cài chọn Visafe")
//            }
//        } else {
//            saveDNS {[weak self] (error) in
//                if let _error = error {
//                    self?.showError(title: "Thông báo", content: _error.localizedDescription)
//                } else {
//                    self?.showError(title: "Thông báo", content: "Vui lòng vào Cài đặt -> Cài đặt chung -> VPN -> DNS để cài chọn Visafe")
//                }
//            }
//        }
    }
    
    @objc func handleEnabelSuccess(sender: Timer) {
        hideAnimationLoading()
        isEnabled = true
        UIView.animate(withDuration: 0.75) {
            self.homeLoadingImage.alpha = 1
        } completion: { (success) in
        }
    }
}

//MARK: - DOH
extension HomeVC {

    func saveDNS(_ onSavedStatus: @escaping (_ error: Error?) -> Void) {
        NEDNSSettingsManager.shared().loadFromPreferences { (error) in
            if let _error = error {
                onSavedStatus(_error)
                return
            }
            let dohSetting = NEDNSOverHTTPSSettings(servers: [])
            dohSetting.serverURL = URL(string: "https://dns-staging.visafe.vn/dns-query/")
            NEDNSSettingsManager.shared().dnsSettings = dohSetting
            NEDNSSettingsManager.shared().saveToPreferences { (saveError) in
                if let _error = saveError {
                    onSavedStatus(_error)
                } else {
                    onSavedStatus(nil)
                }
            }
        }
    }
    
    @available(iOS 14.0, *)
    private func getDnsManagerStatus(_ onStatusReceived: @escaping (_ isInstalled: Bool, _ isEnabled: Bool) -> Void) {
        loadDnsManager { dnsManager in
            guard let manager = dnsManager else {
//                ////DDLogError("Received nil DNS manager")
                onStatusReceived(false, false)
                return
            }
            onStatusReceived(manager.dnsSettings != nil, manager.isEnabled)
        }
    }

    @available(iOS 14.0, *)
    private func loadDnsManager(_ onManagerLoaded: @escaping (_ dnsManager: NEDNSSettingsManager?) -> Void) {
        let dnsManager = NEDNSSettingsManager.shared()
        dnsManager.loadFromPreferences { error in
            if let error = error {
//                ////DDLogError("Error loading DNS manager: \(error)")
                onManagerLoaded(nil)
                return
            }
            onManagerLoaded(dnsManager)
        }
    }

    @available(iOS 14.0, *)
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        loadDnsManager { [weak self] dnsManager in
            guard let dnsManager = dnsManager else {
                onErrorReceived(NativeDnsProviderError.failedToLoadManager)
                return
            }
            dnsManager.removeFromPreferences(completionHandler: onErrorReceived)
            // Check manager status after delete
            self?.getDnsManagerStatus({ [weak self] isInstalled, isEnabled in
                self?.isInstalled = isInstalled
                self?.isEnabled = isEnabled
            })
        }
    }
}

//MARK: - VPN

extension HomeVC {
    private func loadManager(_  complete:@escaping ((NETunnelProviderManager?, Error?) -> Void)) {
//        //////DDLogInfo("(VpnManager) loadManager ")
        providerManagerType.self.loadAllFromPreferences { [weak self] (managers, error) in
            guard let self = self else { return }
            var manager: NETunnelProviderManager?
            var resultError: Error?
            if error != nil {
                resultError = error
//                ////DDLogError("(VpnManager) loadManager error: \(error!)")
                complete(nil, nil)
                return
            }

            if managers?.count ?? 0 == 0 {
//                //////DDLogInfo("(VpnManager) loadManager - manager not installed")
                complete(nil, nil)
                return
            }

            if managers!.count > 1 {
//                ////DDLogError("(VpnManager) loadManager error - there are \(managers!.count) managers installed. Delete all managers")

                for manager in managers! {
                    _ = self.removeManager(manager)
                }

                manager = self.createManager()
                complete(manager, nil)
                return
            }

//            //////DDLogInfo("(VpnManager) loadManager success)")
            manager = managers?.first
            complete(manager, nil)
        }
    }

    private func removeManager(_ manager: NETunnelProviderManager)->Error? {
//        //////DDLogInfo("(VpnManager) - removeManager called")

        var resultError: Error?
        let group = DispatchGroup()
        group.enter()

        manager.removeFromPreferences { (error) in
            resultError = error
            group.leave()
        }

        group.wait()

        return resultError
    }

    private func createManager()->NETunnelProviderManager {

//        //////DDLogInfo("(VpnManager) createManager")

        let manager = providerManagerType.self.init()

        return manager
    }

    private func setupConfiguration(_ manager: NETunnelProviderManager) {
//        //////DDLogInfo("(VpnManager) setupConfiguration called")

        // do not update configuration for not premium users
//        if !appConfiguration.proStatus {
//            return
//        }

        // setup protocol configuration
        let protocolConfiguration = NETunnelProviderProtocol()
        protocolConfiguration.providerBundleIdentifier = "vn.visafe.tunnel"
        protocolConfiguration.serverAddress = "127.0.0.1"
        protocolConfiguration.username = "uid"

        manager.protocolConfiguration = protocolConfiguration
        manager.isEnabled = true

        let connectRule = NEOnDemandRuleConnect()
        connectRule.interfaceTypeMatch = .any
//        connectRule.dnsServerAddressMatch = ["https://dns-staging.visafe.vn/dns-query/"]
//        connectRule.dnsSearchDomainMatch = ["https://dns-staging.visafe.vn/dns-query/"]
//        let evaluationRule = NEEvaluateConnectionRule(matchDomains: ["visafe.vn"], andAction: .connectIfNeeded)
//        evaluationRule.useDNSServers = ["https://dns-staging.visafe.vn/dns-query/"]
//        let onDemandRule = NEOnDemandRuleEvaluateConnection()
//        onDemandRule.connectionRules = [evaluationRule]
//        onDemandRule.interfaceTypeMatch = NEOnDemandRuleInterfaceType.any
        manager.onDemandRules = [connectRule]

        manager.isOnDemandEnabled = true

        manager.localizedDescription = "Visafe"
    }

    private func saveManager(_ manager: NETunnelProviderManager, _ complete:@escaping ((Error?) -> Void)) {
        manager.saveToPreferences { (error) in
            complete(error)
        }
    }
}

extension HomeVC {
    func initVpn() {

        self.loadManager { (oldManager, error) in
            if oldManager != nil {
//                _ = self.removeManager(oldManager!)
                self.manager = oldManager
                self.session = (self.manager.connection as! NETunnelProviderSession)
                do {
                    try self.session.startVPNTunnel(options: nil)
                } catch let error1 {
                    print(error1.localizedDescription)
                }
                return
            }
            let ma = self.createManager()
    //
            self.setupConfiguration(ma)
    //
            self.saveManager(ma, { error in
                if error == nil {
//                    do {
//                        try self.manager.connection.startVPNTunnel()
//                    } catch let error1 {
//                        print(error1.localizedDescription)
//                    }
                    self.initVpn()
                } else {
                    print("save fail")
                }
            })
        }



//
//        self.vpnInstalledValue = error == nil
    }
}
