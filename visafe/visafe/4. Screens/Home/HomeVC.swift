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

    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var earthImageView: UIImageView!
    @IBOutlet weak var connectButton: UIButton!

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var desImageView: UIImageView!

    var providerManagerType: NETunnelProviderManager.Type = NETunnelProviderManager.self
    private var vpnInstalledValue: Bool?
    var manager: NETunnelProviderManager!
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
        connectionView.clipsToBounds = true
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [UIColor.color_0F1733.cgColor, UIColor.color_102366.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }

    func updateUI() {
        firstLabel.text = isEnabled ? "": "Bấm"
        lastLabel.text = isEnabled ? "Đang được bảo vệ": "để bật tính năng bảo vệ"
        desImageView.image = isEnabled ? UIImage(named: "Shield_Done"): UIImage(named: "power")
        earthImageView.image = isEnabled ? UIImage(named: "connection_success"): UIImage(named: "no_connection")
        connectButton.setImage(isEnabled ? UIImage(named: "connect_on"): UIImage(named: "connect_off"), for: .normal)
    }

    @IBAction func connectAction(_ sender: Any) {
        if isInstalled {
            if isEnabled {
                removeDnsManager {[weak self] (error) in
                    if let _error = error {
                        self?.showError(title: "Thông báo", content: _error.localizedDescription)
                    }
                }
            } else {
                showError(title: "Thông báo", content: "Vui lòng vào Cài đặt -> Cài đặt chung -> VPN -> DNS để cài chọn Visafe")
            }
        } else {
            saveDNS {[weak self] (error) in
                if let _error = error {
                    self?.showError(title: "Thông báo", content: _error.localizedDescription)
                } else {
                    self?.showError(title: "Thông báo", content: "Vui lòng vào Cài đặt -> Cài đặt chung -> VPN -> DNS để cài chọn Visafe")
                }
            }
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
//                DDLogError("Received nil DNS manager")
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
//                DDLogError("Error loading DNS manager: \(error)")
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
    func initVpn() {
        loadManager()
    }

    private func setupConfiguration() {


        // setup protocol configuration
        let protocolConfiguration = NETunnelProviderProtocol()
        protocolConfiguration.providerBundleIdentifier = "com.shjn.visafe.networkextention"
        protocolConfiguration.serverAddress = "127.0.0.1"

        manager.protocolConfiguration = protocolConfiguration

        let onDemandRuled = onDemandRules()
        manager.onDemandRules = onDemandRuled

//        if !vpnInstalled {
//            enabled = true // install configuration with enable = true
//        }
//        else {
//           enabled = self.complexProtection?.systemProtectionEnabled ?? false || !vpnInstalled
//        }
//
//        if resources.dnsImplementation == .native {
//            DDLogInfo("(VpnManager) set manager isEnabled = false because native mode is enabled ")
//        }

        manager.isEnabled = true
        manager.isOnDemandEnabled = true

        manager.localizedDescription = "Visafe"
    }


    func onDemandRules() -> [NEOnDemandRule] {
        var onDemandRules = [NEOnDemandRule]()

//        let SSIDs = enabledExceptions.map{ $0.rule }
//        if SSIDs.count > 0 {
//            let disconnectRule = NEOnDemandRuleDisconnect()
//            disconnectRule.ssidMatch = SSIDs
//            onDemandRules.append(disconnectRule)
//        }
//
        let disconnectRule = NEOnDemandRuleDisconnect()

//        switch (filterWifiDataEnabled, filterMobileDataEnabled) {
//        case (false, false):
//            disconnectRule.interfaceTypeMatch = .any
//            onDemandRules.append(disconnectRule)
//        case (false, _):
//            disconnectRule.interfaceTypeMatch = .wiFi
//            onDemandRules.append(disconnectRule)
//        case (_, false):
            disconnectRule.interfaceTypeMatch = .cellular
            onDemandRules.append(disconnectRule)
//        default:
//            break
//        }

        let connectRule = NEOnDemandRuleConnect()
        connectRule.interfaceTypeMatch = .any
        let evaluationRule = NEEvaluateConnectionRule(matchDomains: ["visafe.vn"], andAction: .connectIfNeeded)
        evaluationRule.useDNSServers = ["https://dns-staging.visafe.vn/dns-query/"]


        let onDemandRule = NEOnDemandRuleEvaluateConnection()
                onDemandRule.connectionRules = [evaluationRule]
                onDemandRule.interfaceTypeMatch = NEOnDemandRuleInterfaceType.any
        onDemandRules.append(onDemandRule)
        onDemandRules.append(connectRule)
        return onDemandRules
    }

    private func saveManager()->Error? {

        var resultError: Error?

        let group = DispatchGroup()
        group.enter()

        manager.saveToPreferences { (error) in
            resultError = error
            if error != nil {

            }
            else {
                do {
                    try self.manager.connection.startVPNTunnel()
                } catch {
                    print("(VpnManager) - start tunnel error: \(error.localizedDescription)")
                }
            }
            group.leave()
        }

//        group.wait()

        return resultError
    }

    private func loadManager() {

//        var manager: NETunnelProviderManager?
//        var resultError: Error?
//        let group = DispatchGroup()
//        group.enter()

        providerManagerType.self.loadAllFromPreferences { [weak self] (managers, error) in

//            defer { group.leave() }

            guard let self = self else { return }
            if error != nil {
//                resultError = error
                return
            }
            if managers?.count ?? 0 == 0 {
                self.manager = self.createManager()
                self.setupConfiguration()
                self.saveManager()
                return
            }

            if managers!.count > 1 {
                for manager in managers! {
                    _ = self.removeManager(manager)
                }



                return
            }

//            self.manager = managers?.first
        }

//        group.wait()

//        vpnInstalledValue = manager != nil
//        return (manager, resultError)
//        setupConfiguration(manage!)
//        let (error1) = saveManager(manage!)
    }

    private func removeManager(_ manager: NETunnelProviderManager)->Error? {

        var resultError: Error?
        let group = DispatchGroup()
        group.enter()

        manager.removeFromPreferences { (error) in
            resultError = error
            group.leave()
        }

//        group.wait()

        return resultError
    }

    private func createManager()->NETunnelProviderManager {
        let manager = providerManagerType.self.init()

        return manager
    }
}
