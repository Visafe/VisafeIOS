//
//  DoHNative.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 04/08/2021.
//

import Foundation
import NetworkExtension

class DoHNative {

    static let shared = DoHNative()
    var isEnabled = false {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: updateDnsStatus), object: nil)
        }
    }
    var isInstalled = false

    func saveDNS(_ onSavedStatus: @escaping (_ error: Error?) -> Void) {
        NEDNSSettingsManager.shared().loadFromPreferences { (error) in
            if let _error = error {
                onSavedStatus(_error)
                return
            }
            let dohSetting = NEDNSOverHTTPSSettings(servers: [])
            dohSetting.serverURL = URL(string: Common.getDnsServer())
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
    func getDnsManagerStatus() {
        loadDnsManager { dnsManager in
            guard let manager = dnsManager else {
                self.isInstalled = false
                self.isEnabled = false
                return
            }
            self.isInstalled = manager.dnsSettings != nil
            self.isEnabled = manager.isEnabled
        }
    }

    @available(iOS 14.0, *)
    private func loadDnsManager(_ onManagerLoaded: @escaping (_ dnsManager: NEDNSSettingsManager?) -> Void) {
        let dnsManager = NEDNSSettingsManager.shared()
        dnsManager.loadFromPreferences { error in
            if error != nil {
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
            self?.getDnsManagerStatus()
        }
    }
}

enum NativeDnsProviderError: Error {
    case unsupportedDnsProtocol
    case failedToLoadManager
    case unsupportedProtocolsConfiguration
    case invalidUpstreamsNumber
}
